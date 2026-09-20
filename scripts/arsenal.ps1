<#
.SYNOPSIS
    Claude Code Arsenal — Unified Command-Line Tool (PowerShell)
.EXAMPLE
    .\scripts\arsenal.ps1 check .
    .\scripts\arsenal.ps1 filter -Command "npm test"
#>
[CmdletBinding()]
param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$Command = "help",

    [Parameter(Position=1, Mandatory=$false)]
    [string]$Target = "."
)

$scriptDir = $PSScriptRoot

switch ($Command.ToLower()) {
    "install" {
        & "$scriptDir\install.ps1" -TargetPath $Target
    }
    "check" {
        & "$scriptDir\fast-check.ps1" -Target $Target
    }
    "validate" {
        & "$scriptDir\validate.ps1" -TargetPath $Target
    }
    "filter" {
        & "$scriptDir\log-filter.ps1" -Command $Target
    }
    default {
        Write-Host "Claude Code Arsenal CLI Tool (PowerShell)" -ForegroundColor Cyan
        Write-Host "Commands: install, check, validate, filter, help"
    }
}
