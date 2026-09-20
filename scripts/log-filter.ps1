<#
.SYNOPSIS
    Claude Code Arsenal — Log Filter (PowerShell)
.DESCRIPTION
    Runs a command and filters output to retain only errors, failures, and stack traces.
.EXAMPLE
    .\scripts\log-filter.ps1 -Command "npm test"
#>
[CmdletBinding()]
param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$Command
)

$ErrorActionPreference = "Continue"
$FilterRegex = "FAIL|ERROR|Error|FAILED|Exception|Traceback|AssertionError|panic:|fatal:|\[ERROR\]|\[FAIL\]"

if ($Command) {
    $tempFile = [System.IO.Path]::GetTempFileName()
    try {
        $hasError = $false
        try {
            Invoke-Expression $Command *>&1 | Out-File -FilePath $tempFile -Encoding utf8
        } catch {
            $hasError = $true
        }
        
        $exitCode = if ($null -ne $LASTEXITCODE) { $LASTEXITCODE } else { 0 }
        if ($hasError) { $exitCode = 1 }

        $content = Get-Content $tempFile -ErrorAction SilentlyContinue

        if ($exitCode -eq 0 -and -not $hasError) {
            Write-Host "PASS: Command finished successfully. Summary:" -ForegroundColor Green
            $matches = $content | Select-String -Pattern "pass|passed|success|ok|completed" -SimpleMatch
            if ($matches) {
                $matches | Select-Object -Last 10
            } else {
                $content | Select-Object -Last 10
            }
        } else {
            Write-Host "FAIL: Command failed. Filtered output:" -ForegroundColor Red
            Write-Host "--------------------------------------------------------"
            $matches = $content | Select-String -Pattern $FilterRegex
            if ($matches) {
                $content | Select-String -Pattern $FilterRegex -Context 2,15 | Select-Object -First 50
            } else {
                $content | Select-Object -Last 40
            }
            Write-Host "--------------------------------------------------------"
        }
    } finally {
        if (Test-Path $tempFile) { Remove-Item $tempFile -Force }
    }
} else {
    Write-Host "Usage: .\scripts\log-filter.ps1 -Command '<command>'"
}
