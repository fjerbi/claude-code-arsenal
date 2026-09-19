<#
.SYNOPSIS
    Claude Code Arsenal — PowerShell Install Script

.DESCRIPTION
    Copies Arsenal files into a target project or global Claude Code config.
    Idempotent: safe to re-run. Existing CLAUDE.md is backed up, not overwritten.

.PARAMETER TargetPath
    Path to the project root where Arsenal will be installed.

.PARAMETER Global
    Install to Claude Code user-level config.

.PARAMETER Force
    Overwrite existing CLAUDE.md without backup.

.PARAMETER NoHooks
    Skip installing git hooks.

.EXAMPLE
    .\scripts\install.ps1 -TargetPath "C:\Projects\my-app"

.EXAMPLE
    .\scripts\install.ps1 -Global
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$TargetPath,

    [switch]$Global,
    [switch]$Force,
    [switch]$NoHooks
)

$ErrorActionPreference = "Stop"
$ArsenalVersion = "1.0.0"
$ScriptDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

function Write-Header {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Blue
    Write-Host "  Claude Code Arsenal -- Installer v$ArsenalVersion" -ForegroundColor Blue
    Write-Host "===============================================" -ForegroundColor Blue
    Write-Host ""
}

function Write-Success { param([string]$Message) Write-Host "[+] $Message" -ForegroundColor Green }
function Write-Warn    { param([string]$Message) Write-Host "[!] $Message" -ForegroundColor Yellow }
function Write-Err     { param([string]$Message) Write-Host "[x] $Message" -ForegroundColor Red }
function Write-Info    { param([string]$Message) Write-Host "[>] $Message" -ForegroundColor Blue }

function Install-ArsenalFile {
    param(
        [string]$Source,
        [string]$Destination
    )
    $destDir = Split-Path -Parent $Destination
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    Copy-Item -Path $Source -Destination $Destination -Force
    Write-Success "Installed $(Split-Path -Leaf $Destination)"
}

function Backup-ArsenalFile {
    param([string]$FilePath)
    if (Test-Path $FilePath) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backup = "$FilePath.arsenal-backup.$timestamp"
        Copy-Item -Path $FilePath -Destination $backup
        Write-Warn "Backed up existing $(Split-Path -Leaf $FilePath) → $(Split-Path -Leaf $backup)"
    }
}

function Install-Project {
    param(
        [string]$Target,
        [bool]$ForceOverwrite,
        [bool]$SkipHooks
    )

    if (-not (Test-Path $Target -PathType Container)) {
        Write-Err "Target directory does not exist: $Target"
        exit 1
    }

    Write-Info "Installing Arsenal into: $Target"
    Write-Host ""

    # CLAUDE.md
    $claudeMd = Join-Path $Target "CLAUDE.md"
    if ((Test-Path $claudeMd) -and -not $ForceOverwrite) {
        Backup-ArsenalFile $claudeMd
    }
    Install-ArsenalFile (Join-Path $ScriptDir "CLAUDE.md") $claudeMd

    # AGENTS.md
    $agentsMd = Join-Path $Target "AGENTS.md"
    if ((Test-Path $agentsMd) -and -not $ForceOverwrite) {
        Backup-ArsenalFile $agentsMd
    }
    Install-ArsenalFile (Join-Path $ScriptDir "AGENTS.md") $agentsMd

    # .claude/ config
    Write-Info "Installing .claude/ configuration..."
    Install-ArsenalFile (Join-Path $ScriptDir ".claude\constitution.md") (Join-Path $Target ".claude\constitution.md")
    Install-ArsenalFile (Join-Path $ScriptDir ".claude\settings.json") (Join-Path $Target ".claude\settings.json")

    # Agents
    Write-Info "Installing agents..."
    Get-ChildItem (Join-Path $ScriptDir ".claude\agents\*.md") | ForEach-Object {
        Install-ArsenalFile $_.FullName (Join-Path $Target ".claude\agents\$($_.Name)")
    }

    # Commands
    Write-Info "Installing commands..."
    Get-ChildItem (Join-Path $ScriptDir ".claude\commands\*.md") | ForEach-Object {
        Install-ArsenalFile $_.FullName (Join-Path $Target ".claude\commands\$($_.Name)")
    }

    # Hooks
    if (-not $SkipHooks) {
        Write-Info "Installing hooks..."
        Get-ChildItem (Join-Path $ScriptDir ".claude\hooks\*.sh") | ForEach-Object {
            Install-ArsenalFile $_.FullName (Join-Path $Target ".claude\hooks\$($_.Name)")
        }
    } else {
        Write-Warn "Skipping hooks (-NoHooks)"
    }

    # Templates
    Write-Info "Installing templates..."
    Get-ChildItem (Join-Path $ScriptDir ".claude\templates\*.md") | ForEach-Object {
        Install-ArsenalFile $_.FullName (Join-Path $Target ".claude\templates\$($_.Name)")
    }

    # Docs
    Write-Info "Installing documentation..."
    Get-ChildItem (Join-Path $ScriptDir "docs\*.md") | ForEach-Object {
        Install-ArsenalFile $_.FullName (Join-Path $Target "docs\$($_.Name)")
    }

    Write-Host ""
    Write-Success "Arsenal v$ArsenalVersion installed successfully!"
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "  1. Review CLAUDE.md and customize for your project"
    Write-Host "  2. Review .claude\settings.json and adjust permissions"
    Write-Host "  3. Run: bash scripts/validate.sh $Target"
    Write-Host ""
}

function Install-Global {
    $globalDir = if ($env:CLAUDE_CONFIG_DIR) {
        $env:CLAUDE_CONFIG_DIR
    } else {
        Join-Path $env:USERPROFILE ".claude"
    }

    Write-Info "Installing Arsenal globally to: $globalDir"
    Write-Host ""

    if (-not (Test-Path $globalDir)) {
        New-Item -ItemType Directory -Path $globalDir -Force | Out-Null
    }

    $claudeMd = Join-Path $globalDir "CLAUDE.md"
    if (Test-Path $claudeMd) {
        Backup-ArsenalFile $claudeMd
    }

    Install-ArsenalFile (Join-Path $ScriptDir "CLAUDE.md") $claudeMd
    Install-ArsenalFile (Join-Path $ScriptDir ".claude\constitution.md") (Join-Path $globalDir "constitution.md")

    Write-Host ""
    Write-Success "Arsenal installed globally!"
    Write-Info "Core rules will apply to all projects using Claude Code."
    Write-Host ""
}

# --- Main ---

Write-Header

if ($Global) {
    Install-Global
} elseif ($TargetPath) {
    Install-Project -Target $TargetPath -ForceOverwrite $Force.IsPresent -SkipHooks $NoHooks.IsPresent
} else {
    Write-Err "No target specified."
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\scripts\install.ps1 -TargetPath `"C:\path\to\project`""
    Write-Host "  .\scripts\install.ps1 -Global"
    exit 1
}
