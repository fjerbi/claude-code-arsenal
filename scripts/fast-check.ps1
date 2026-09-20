<#
.SYNOPSIS
    Claude Code Arsenal — Fast Check (PowerShell)
.DESCRIPTION
    Performs deterministic local checks in <300ms.
    Replaces sequential multi-step LLM tool calls.
.EXAMPLE
    .\scripts\fast-check.ps1 -Target "."
#>
[CmdletBinding()]
param(
    [Parameter(Position=0, Mandatory=$false)]
    [string]$Target = "."
)

$ErrorActionPreference = "Continue"
$errCount = 0
$warnCount = 0

Write-Host "Arsenal Fast Check Target: $Target" -ForegroundColor Cyan

# 1. JSON Check
$settingsPath = Join-Path $Target ".claude\settings.json"
if (Test-Path $settingsPath) {
    try {
        $raw = Get-Content $settingsPath -Raw
        $json = $raw | ConvertFrom-Json
        Write-Host "PASS: Settings JSON valid" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: .claude/settings.json contains invalid JSON" -ForegroundColor Red
        $errCount++
    }
}

# 2. Conflict Markers Check
$conflictFiles = Get-ChildItem -Path $Target -Recurse -Exclude ".git","node_modules" -File -ErrorAction SilentlyContinue | Where-Object {
    $lines = Get-Content $_.FullName -TotalCount 20 -ErrorAction SilentlyContinue
    if ($lines) {
        $lines -match "^\<\<\<\<\<\<\< "
    } else {
        $false
    }
}

if ($conflictFiles) {
    Write-Host "ERROR: Git merge conflict markers found" -ForegroundColor Red
    $errCount++
} else {
    Write-Host "PASS: No git merge conflict markers found" -ForegroundColor Green
}

Write-Host "--------------------------------------------------------"
if ($errCount -eq 0) {
    Write-Host "STATUS: PASS (Errors: 0, Warnings: $warnCount)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "STATUS: FAIL (Errors: $errCount, Warnings: $warnCount)" -ForegroundColor Red
    exit 1
}
