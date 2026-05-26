param(
    [Parameter(Mandatory = $true)]
    [string]$ServerInstance,
    [string]$DatabaseName = "Marketplace_Analytics",
    [string]$OutputPath = ".\documentation\sql_execution_outputs",
    [string[]]$SqlFiles = @(
        ".\sql\01_data_import_checks.sql",
        ".\sql\02_data_quality_checks.sql",
        ".\sql\05_validation_queries.sql"
    ),
    [string]$SummaryName = "sql_output_summary"
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$OutputFullPath = Join-Path $ProjectRoot $OutputPath
New-Item -ItemType Directory -Force -Path $OutputFullPath | Out-Null

$connectionString = "Server=$ServerInstance;Database=$DatabaseName;Integrated Security=SSPI;Encrypt=False;TrustServerCertificate=True;Connection Timeout=30"

function Split-SqlBatches {
    param([string]$SqlText)
    $lines = $SqlText -split "`r?`n"
    $batches = New-Object System.Collections.Generic.List[string]
    $current = New-Object System.Text.StringBuilder
    foreach ($line in $lines) {
        if ($line -match "^\s*GO\s*$") {
            $batch = $current.ToString().Trim()
            if ($batch) { $batches.Add($batch) }
            [void]$current.Clear()
        }
        else {
            [void]$current.AppendLine($line)
        }
    }
    $lastBatch = $current.ToString().Trim()
    if ($lastBatch) { $batches.Add($lastBatch) }
    return $batches
}

function Export-DataTable {
    param(
        [System.Data.DataTable]$Table,
        [string]$Path
    )
    $rows = foreach ($dataRow in $Table.Rows) {
        $object = [ordered]@{}
        foreach ($column in $Table.Columns) {
            $object[$column.ColumnName] = $dataRow[$column.ColumnName]
        }
        [PSCustomObject]$object
    }
    $rows | Export-Csv -NoTypeInformation -Path $Path -Encoding UTF8
}

$summary = @()

foreach ($sqlFile in $SqlFiles) {
    $sqlPath = Resolve-Path -LiteralPath (Join-Path $ProjectRoot $sqlFile)
    $fileStem = [IO.Path]::GetFileNameWithoutExtension($sqlPath)
    $sqlText = Get-Content -Raw -LiteralPath $sqlPath
    $batchIndex = 0
    $resultIndex = 0

    foreach ($batch in (Split-SqlBatches -SqlText $sqlText)) {
        $batchIndex += 1
        $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
        $connection.Open()
        $command = $connection.CreateCommand()
        $command.CommandTimeout = 0
        $command.CommandText = $batch
        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($command)
        $dataSet = New-Object System.Data.DataSet
        [void]$adapter.Fill($dataSet)
        $connection.Close()

        foreach ($table in $dataSet.Tables) {
            if ($table.Columns.Count -eq 0) {
                continue
            }
            $resultIndex += 1
            $csvName = "{0}_result_{1:00}.csv" -f $fileStem, $resultIndex
            $csvPath = Join-Path $OutputFullPath $csvName
            Export-DataTable -Table $table -Path $csvPath
            $summary += [PSCustomObject]@{
                sql_file = [IO.Path]::GetFileName($sqlPath)
                batch = $batchIndex
                result_set = $resultIndex
                rows = $table.Rows.Count
                output_file = $csvName
            }
        }
    }
}

$summaryPath = Join-Path $OutputFullPath "$SummaryName.json"
$summary | ConvertTo-Json -Depth 4 | Set-Content -Path $summaryPath -Encoding UTF8

$mdPath = Join-Path $OutputFullPath "$SummaryName.md"
$lines = @("# SQL Output Summary", "", "Summary name: ``$SummaryName``", "", "| SQL File | Result Set | Rows | Output File |", "| --- | --- | --- | --- |")
foreach ($row in $summary) {
    $lines += "| $($row.sql_file) | $($row.result_set) | $($row.rows) | $($row.output_file) |"
}
$lines | Set-Content -Path $mdPath -Encoding UTF8
Write-Host "SQL outputs written to $OutputFullPath"
