param(
    [string]$ServerInstance = "",
    [string]$DatabaseName = "Marketplace_Analytics",
    [string]$RawDataPath = ".\data\raw",
    [string]$OutputPath = ".\documentation\sql_execution_outputs",
    [switch]$NoExitOnFailure
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$RawDataFullPath = Resolve-Path -LiteralPath (Join-Path $ProjectRoot $RawDataPath) -ErrorAction SilentlyContinue
$OutputFullPath = Join-Path $ProjectRoot $OutputPath
New-Item -ItemType Directory -Force -Path $OutputFullPath | Out-Null

$expectedFiles = @(
    "olist_customers_dataset.csv",
    "olist_geolocation_dataset.csv",
    "olist_orders_dataset.csv",
    "olist_order_items_dataset.csv",
    "olist_order_payments_dataset.csv",
    "olist_order_reviews_dataset.csv",
    "olist_products_dataset.csv",
    "olist_sellers_dataset.csv",
    "product_category_name_translation.csv"
)

function Test-SqlConnection {
    param([string]$Instance)

    try {
        $connectionString = "Server=$Instance;Integrated Security=SSPI;Encrypt=False;TrustServerCertificate=True;Connection Timeout=5"
        $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
        $connection.Open()
        $command = $connection.CreateCommand()
        $command.CommandText = "SELECT @@SERVERNAME"
        $serverName = [string]$command.ExecuteScalar()
        $connection.Close()
        [PSCustomObject]@{
            instance = $Instance
            reachable = $true
            result = $serverName
        }
    }
    catch {
        [PSCustomObject]@{
            instance = $Instance
            reachable = $false
            result = $_.Exception.Message
        }
    }
}

$toolNames = @("sqlcmd", "bcp", "powershell", "pwsh", "python", "py")
$tools = foreach ($tool in $toolNames) {
    $command = Get-Command $tool -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        tool = $tool
        path = if ($command) { $command.Source } else { $null }
    }
}

$csvFiles = foreach ($file in $expectedFiles) {
    $path = if ($RawDataFullPath) { Join-Path $RawDataFullPath $file } else { Join-Path (Join-Path $ProjectRoot $RawDataPath) $file }
    [PSCustomObject]@{
        file = $file
        exists = Test-Path -LiteralPath $path
        length_bytes = if (Test-Path -LiteralPath $path) { (Get-Item -LiteralPath $path).Length } else { $null }
    }
}

$services = Get-Service -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "MSSQL*" -or $_.Name -like "SQLBrowser" -or $_.DisplayName -like "*SQL Server*" } |
    Select-Object Name, DisplayName, Status

$candidateInstances = if ($ServerInstance) {
    @($ServerInstance)
}
else {
    @("localhost", ".", "127.0.0.1", "(local)", ".\SQLEXPRESS", "(localdb)\MSSQLLocalDB", "lpc:(local)", "np:\\.\pipe\sql\query")
}

$connectionAttempts = foreach ($candidate in $candidateInstances) {
    Test-SqlConnection -Instance $candidate
}

$summary = [PSCustomObject]@{
    checked_at = (Get-Date).ToString("s")
    project_root = [string]$ProjectRoot
    raw_data_path = if ($RawDataFullPath) { [string]$RawDataFullPath } else { [string](Join-Path $ProjectRoot $RawDataPath) }
    database_name = $DatabaseName
    tools = $tools
    csv_files = $csvFiles
    sql_services = $services
    connection_attempts = $connectionAttempts
    selected_instance = ($connectionAttempts | Where-Object { $_.reachable } | Select-Object -First 1 -ExpandProperty instance)
}

$jsonPath = Join-Path $OutputFullPath "environment_check.json"
$mdPath = Join-Path $OutputFullPath "environment_check.md"
$summary | ConvertTo-Json -Depth 6 | Set-Content -Path $jsonPath -Encoding UTF8

$lines = @(
    "# Environment Check",
    "",
    "Generated: $($summary.checked_at)",
    "",
    "## Project",
    "",
    "- Project root: ``$($summary.project_root)``",
    "- Raw data path: ``$($summary.raw_data_path)``",
    "- Database: ``$DatabaseName``",
    "",
    "## Tooling",
    "",
    "| Tool | Path |",
    "| --- | --- |"
)
foreach ($tool in $tools) {
    $lines += "| $($tool.tool) | $($tool.path) |"
}
$lines += @("", "## Required CSV Files", "", "| File | Exists | Bytes |", "| --- | --- | --- |")
foreach ($file in $csvFiles) {
    $lines += "| $($file.file) | $($file.exists) | $($file.length_bytes) |"
}
$lines += @("", "## SQL Server Services", "", "| Name | Display Name | Status |", "| --- | --- | --- |")
foreach ($service in $services) {
    $lines += "| $($service.Name) | $($service.DisplayName) | $($service.Status) |"
}
$lines += @("", "## SQL Connection Attempts", "", "| Instance | Reachable | Result |", "| --- | --- | --- |")
foreach ($attempt in $connectionAttempts) {
    $safeResult = ([string]$attempt.result).Replace("|", "\|")
    $lines += "| $($attempt.instance) | $($attempt.reachable) | $safeResult |"
}
$lines += @("", "Selected instance: ``$($summary.selected_instance)``", "")
$lines | Set-Content -Path $mdPath -Encoding UTF8

Write-Host "Environment check written to $mdPath"
if (-not $summary.selected_instance) {
    Write-Warning "No reachable SQL Server instance was detected."
    if (-not $NoExitOnFailure) {
        exit 2
    }
}
else {
    Write-Host "Reachable SQL Server instance: $($summary.selected_instance)"
}
