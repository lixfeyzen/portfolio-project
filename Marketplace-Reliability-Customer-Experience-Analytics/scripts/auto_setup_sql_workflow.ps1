param(
    [string]$ServerInstance = "",
    [string]$DatabaseName = "Marketplace_Analytics",
    [string]$RawDataPath = ".\data\raw",
    [string]$OutputPath = ".\documentation\sql_execution_outputs",
    [ValidateSet("Stop", "Append", "Truncate")]
    [string]$IfTableHasRows = "Stop",
    [string]$PythonPath = ""
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$OutputFullPath = Join-Path $ProjectRoot $OutputPath
New-Item -ItemType Directory -Force -Path $OutputFullPath | Out-Null

$logPath = Join-Path $OutputFullPath "auto_setup_sql_workflow.log"
Start-Transcript -Path $logPath -Force | Out-Null
try {
    if (-not $PythonPath) {
        $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
        if ($pythonCommand) {
            $PythonPath = $pythonCommand.Source
        }
        else {
            $pyCommand = Get-Command py -ErrorAction SilentlyContinue
            if ($pyCommand) {
                $PythonPath = $pyCommand.Source
            }
        }
    }

    if ($PythonPath) {
        & $PythonPath (Join-Path $PSScriptRoot "profile_data.py") `
            --input-dir (Join-Path $ProjectRoot $RawDataPath) `
            --output (Join-Path $ProjectRoot "documentation\data_profile_summary.md") `
            --json-output (Join-Path $ProjectRoot "documentation\data_profile_summary.json") `
            --source-label "project data/raw directory"
    }
    else {
        Write-Warning "Python was not found. Skipping CSV profiling."
    }

    & (Join-Path $PSScriptRoot "check_environment.ps1") `
        -ServerInstance $ServerInstance `
        -DatabaseName $DatabaseName `
        -RawDataPath $RawDataPath `
        -OutputPath $OutputPath `
        -NoExitOnFailure

    $environment = Get-Content -Raw (Join-Path $OutputFullPath "environment_check.json") | ConvertFrom-Json
    $selectedInstance = if ($ServerInstance) { $ServerInstance } else { [string]$environment.selected_instance }
    if ([string]::IsNullOrWhiteSpace($selectedInstance)) {
        throw "No reachable SQL Server instance was detected. See documentation/sql_execution_outputs/environment_check.md."
    }

    & (Join-Path $PSScriptRoot "run_sql_workflow.ps1") `
        -ServerInstance $selectedInstance `
        -DatabaseName $DatabaseName `
        -RawDataPath $RawDataPath `
        -OutputPath $OutputPath `
        -IfTableHasRows $IfTableHasRows

    Write-Host "Automated SQL setup completed."
}
finally {
    Stop-Transcript | Out-Null
}
