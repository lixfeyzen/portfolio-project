param(
    [Parameter(Mandatory = $true)]
    [string]$ServerInstance,
    [string]$DatabaseName = "Marketplace_Analytics",
    [string]$RawDataPath = ".\data\raw",
    [string]$OutputPath = ".\documentation\sql_execution_outputs",
    [ValidateSet("Stop", "Append", "Truncate")]
    [string]$IfTableHasRows = "Stop",
    [switch]$SkipImport
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$OutputFullPath = Join-Path $ProjectRoot $OutputPath
New-Item -ItemType Directory -Force -Path $OutputFullPath | Out-Null

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

function Invoke-SqlFile {
    param(
        [string]$SqlFile,
        [string]$Database = "master"
    )
    $sqlPath = Resolve-Path -LiteralPath (Join-Path $ProjectRoot $SqlFile)
    $sqlText = Get-Content -Raw -LiteralPath $sqlPath
    $connectionString = "Server=$ServerInstance;Database=$Database;Integrated Security=SSPI;Encrypt=False;TrustServerCertificate=True;Connection Timeout=30"
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    foreach ($batch in (Split-SqlBatches -SqlText $sqlText)) {
        $command = $connection.CreateCommand()
        $command.CommandTimeout = 0
        $command.CommandText = $batch
        [void]$command.ExecuteNonQuery()
    }
    $connection.Close()
    Write-Host "Executed $SqlFile"
}

$logPath = Join-Path $OutputFullPath "run_sql_workflow.log"
Start-Transcript -Path $logPath -Force | Out-Null
try {
    Invoke-SqlFile -SqlFile ".\sql\00_create_database_and_raw_tables.sql" -Database "master"

    if (-not $SkipImport) {
        & (Join-Path $PSScriptRoot "import_csv_to_sqlserver.ps1") `
            -ServerInstance $ServerInstance `
            -DatabaseName $DatabaseName `
            -RawDataPath $RawDataPath `
            -OutputPath $OutputPath `
            -IfTableHasRows $IfTableHasRows
    }
    else {
        Write-Host "Skipping CSV import because -SkipImport was provided."
    }

    Invoke-SqlFile -SqlFile ".\sql\03_cleaning_views.sql" -Database $DatabaseName
    Invoke-SqlFile -SqlFile ".\sql\04_analysis_views.sql" -Database $DatabaseName

    & (Join-Path $PSScriptRoot "export_sql_validation_outputs.ps1") `
        -ServerInstance $ServerInstance `
        -DatabaseName $DatabaseName `
        -OutputPath $OutputPath `
        -SqlFiles @(".\sql\01_data_import_checks.sql", ".\sql\02_data_quality_checks.sql", ".\sql\05_validation_queries.sql") `
        -SummaryName "validation_sql_output_summary"

    Write-Host "SQL workflow completed successfully."
}
finally {
    Stop-Transcript | Out-Null
}
