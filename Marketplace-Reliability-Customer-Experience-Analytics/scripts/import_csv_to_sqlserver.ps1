param(
    [Parameter(Mandatory = $true)]
    [string]$ServerInstance,
    [string]$DatabaseName = "Marketplace_Analytics",
    [string]$RawDataPath = ".\data\raw",
    [string]$OutputPath = ".\documentation\sql_execution_outputs",
    [ValidateSet("Stop", "Append", "Truncate")]
    [string]$IfTableHasRows = "Stop",
    [int]$BatchSize = 5000
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName Microsoft.VisualBasic

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$RawDataFullPath = Resolve-Path -LiteralPath (Join-Path $ProjectRoot $RawDataPath)
$OutputFullPath = Join-Path $ProjectRoot $OutputPath
New-Item -ItemType Directory -Force -Path $OutputFullPath | Out-Null

$connectionString = "Server=$ServerInstance;Database=$DatabaseName;Integrated Security=SSPI;Encrypt=False;TrustServerCertificate=True;Connection Timeout=30"

function Invoke-Scalar {
    param([string]$Sql)
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = $Sql
    $value = $command.ExecuteScalar()
    $connection.Close()
    return $value
}

function Invoke-NonQuery {
    param([string]$Sql)
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandTimeout = 0
    $command.CommandText = $Sql
    [void]$command.ExecuteNonQuery()
    $connection.Close()
}

function New-ColumnSpec {
    param([string]$Name, [type]$Type)
    [PSCustomObject]@{ Name = $Name; Type = $Type }
}

$schemas = @{
    raw_customers = @(
        New-ColumnSpec "customer_id" ([string])
        New-ColumnSpec "customer_unique_id" ([string])
        New-ColumnSpec "customer_zip_code_prefix" ([string])
        New-ColumnSpec "customer_city" ([string])
        New-ColumnSpec "customer_state" ([string])
    )
    raw_geolocation = @(
        New-ColumnSpec "geolocation_zip_code_prefix" ([string])
        New-ColumnSpec "geolocation_lat" ([decimal])
        New-ColumnSpec "geolocation_lng" ([decimal])
        New-ColumnSpec "geolocation_city" ([string])
        New-ColumnSpec "geolocation_state" ([string])
    )
    raw_orders = @(
        New-ColumnSpec "order_id" ([string])
        New-ColumnSpec "customer_id" ([string])
        New-ColumnSpec "order_status" ([string])
        New-ColumnSpec "order_purchase_timestamp" ([string])
        New-ColumnSpec "order_approved_at" ([string])
        New-ColumnSpec "order_delivered_carrier_date" ([string])
        New-ColumnSpec "order_delivered_customer_date" ([string])
        New-ColumnSpec "order_estimated_delivery_date" ([string])
    )
    raw_order_items = @(
        New-ColumnSpec "order_id" ([string])
        New-ColumnSpec "order_item_id" ([int])
        New-ColumnSpec "product_id" ([string])
        New-ColumnSpec "seller_id" ([string])
        New-ColumnSpec "shipping_limit_date" ([string])
        New-ColumnSpec "price" ([decimal])
        New-ColumnSpec "freight_value" ([decimal])
    )
    raw_order_payments = @(
        New-ColumnSpec "order_id" ([string])
        New-ColumnSpec "payment_sequential" ([int])
        New-ColumnSpec "payment_type" ([string])
        New-ColumnSpec "payment_installments" ([int])
        New-ColumnSpec "payment_value" ([decimal])
    )
    raw_order_reviews = @(
        New-ColumnSpec "review_id" ([string])
        New-ColumnSpec "order_id" ([string])
        New-ColumnSpec "review_score" ([int])
        New-ColumnSpec "review_comment_title" ([string])
        New-ColumnSpec "review_comment_message" ([string])
        New-ColumnSpec "review_creation_date" ([string])
        New-ColumnSpec "review_answer_timestamp" ([string])
    )
    raw_products = @(
        New-ColumnSpec "product_id" ([string])
        New-ColumnSpec "product_category_name" ([string])
        New-ColumnSpec "product_name_lenght" ([int])
        New-ColumnSpec "product_description_lenght" ([int])
        New-ColumnSpec "product_photos_qty" ([int])
        New-ColumnSpec "product_weight_g" ([int])
        New-ColumnSpec "product_length_cm" ([int])
        New-ColumnSpec "product_height_cm" ([int])
        New-ColumnSpec "product_width_cm" ([int])
    )
    raw_sellers = @(
        New-ColumnSpec "seller_id" ([string])
        New-ColumnSpec "seller_zip_code_prefix" ([string])
        New-ColumnSpec "seller_city" ([string])
        New-ColumnSpec "seller_state" ([string])
    )
    raw_category_translation = @(
        New-ColumnSpec "product_category_name" ([string])
        New-ColumnSpec "product_category_name_english" ([string])
    )
}

$fileMap = @(
    [PSCustomObject]@{ File = "olist_customers_dataset.csv"; Table = "raw_customers" }
    [PSCustomObject]@{ File = "olist_geolocation_dataset.csv"; Table = "raw_geolocation" }
    [PSCustomObject]@{ File = "olist_orders_dataset.csv"; Table = "raw_orders" }
    [PSCustomObject]@{ File = "olist_order_items_dataset.csv"; Table = "raw_order_items" }
    [PSCustomObject]@{ File = "olist_order_payments_dataset.csv"; Table = "raw_order_payments" }
    [PSCustomObject]@{ File = "olist_order_reviews_dataset.csv"; Table = "raw_order_reviews" }
    [PSCustomObject]@{ File = "olist_products_dataset.csv"; Table = "raw_products" }
    [PSCustomObject]@{ File = "olist_sellers_dataset.csv"; Table = "raw_sellers" }
    [PSCustomObject]@{ File = "product_category_name_translation.csv"; Table = "raw_category_translation" }
)

function Convert-CellValue {
    param([string]$Value, [type]$Type)
    if ($null -eq $Value -or $Value.Trim() -eq "") {
        return [DBNull]::Value
    }
    if ($Type -eq [string]) {
        return $Value
    }
    if ($Type -eq [int]) {
        return [int]::Parse($Value, [Globalization.CultureInfo]::InvariantCulture)
    }
    if ($Type -eq [decimal]) {
        return [decimal]::Parse($Value, [Globalization.CultureInfo]::InvariantCulture)
    }
    return $Value
}

function New-DataTableForSchema {
    param($Schema)
    $table = New-Object System.Data.DataTable
    foreach ($column in $Schema) {
        [void]$table.Columns.Add($column.Name, $column.Type)
    }
    Write-Output -NoEnumerate $table
}

function Flush-BulkCopy {
    param(
        [System.Data.DataTable]$DataTable,
        [string]$DestinationTable,
        [ref]$InsertedRows
    )

    if ($DataTable.Rows.Count -eq 0) {
        return
    }

    $bulkCopy = New-Object System.Data.SqlClient.SqlBulkCopy($connectionString, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock)
    $bulkCopy.DestinationTableName = "dbo.$DestinationTable"
    $bulkCopy.BatchSize = $BatchSize
    $bulkCopy.BulkCopyTimeout = 0
    foreach ($column in $DataTable.Columns) {
        [void]$bulkCopy.ColumnMappings.Add($column.ColumnName, $column.ColumnName)
    }
    $bulkCopy.WriteToServer($DataTable)
    $bulkCopy.Close()
    $InsertedRows.Value += $DataTable.Rows.Count
    $DataTable.Clear()
}

$summary = @()

foreach ($mapping in $fileMap) {
    $csvPath = Join-Path $RawDataFullPath $mapping.File
    if (-not (Test-Path -LiteralPath $csvPath)) {
        throw "Required CSV not found: $csvPath"
    }

    $existingRows = [int](Invoke-Scalar "SELECT COUNT(*) FROM dbo.$($mapping.Table);")
    if ($existingRows -gt 0) {
        if ($IfTableHasRows -eq "Stop") {
            throw "Table dbo.$($mapping.Table) already has $existingRows rows. Re-run with -IfTableHasRows Truncate or Append."
        }
        if ($IfTableHasRows -eq "Truncate") {
            Invoke-NonQuery "TRUNCATE TABLE dbo.$($mapping.Table);"
        }
    }

    $schema = $schemas[$mapping.Table]
    $dataTable = New-DataTableForSchema -Schema $schema
    $insertedRows = 0

    $parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($csvPath)
    $parser.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
    $parser.SetDelimiters(",")
    $parser.HasFieldsEnclosedInQuotes = $true

    $headers = $parser.ReadFields()
    $expectedHeaders = @($schema | ForEach-Object { $_.Name })
    if (($headers -join "|") -ne ($expectedHeaders -join "|")) {
        throw "Header mismatch for $($mapping.File). Expected $($expectedHeaders -join ', '), got $($headers -join ', ')."
    }

    while (-not $parser.EndOfData) {
        $fields = $parser.ReadFields()
        $row = $dataTable.NewRow()
        for ($i = 0; $i -lt $schema.Count; $i++) {
            $row[$schema[$i].Name] = Convert-CellValue -Value $fields[$i] -Type $schema[$i].Type
        }
        [void]$dataTable.Rows.Add($row)
        if ($dataTable.Rows.Count -ge $BatchSize) {
            Flush-BulkCopy -DataTable $dataTable -DestinationTable $mapping.Table -InsertedRows ([ref]$insertedRows)
        }
    }
    Flush-BulkCopy -DataTable $dataTable -DestinationTable $mapping.Table -InsertedRows ([ref]$insertedRows)
    $parser.Close()

    $summary += [PSCustomObject]@{
        file = $mapping.File
        table = $mapping.Table
        inserted_rows = $insertedRows
    }
    Write-Host "Imported $($mapping.File) -> dbo.$($mapping.Table): $insertedRows rows"
}

$jsonPath = Join-Path $OutputFullPath "import_summary.json"
$mdPath = Join-Path $OutputFullPath "import_summary.md"
$summary | ConvertTo-Json -Depth 4 | Set-Content -Path $jsonPath -Encoding UTF8

$lines = @("# Import Summary", "", "| File | Table | Inserted Rows |", "| --- | --- | --- |")
foreach ($row in $summary) {
    $lines += "| $($row.file) | $($row.table) | $($row.inserted_rows) |"
}
$lines | Set-Content -Path $mdPath -Encoding UTF8
Write-Host "Import summary written to $mdPath"
