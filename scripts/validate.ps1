<#
.SYNOPSIS
    Claude Code Arsenal — Validation Script (PowerShell)
.DESCRIPTION
    Validates that an Arsenal installation is complete and consistent.
.EXAMPLE
    .\scripts\validate.ps1 -TargetPath C:\path\to\project
    .\scripts\validate.ps1 -TargetPath .
    .\scripts\validate.ps1 -Self
.NOTES
    Exit codes: 0 = all checks passed, 1 = one or more checks failed.
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory = $false)]
    [string]$TargetPath,

    [switch]$Self
)

$ScriptDir = Split-Path -Parent $PSScriptRoot
if (-not $ScriptDir) { $ScriptDir = Split-Path -Parent $PSScriptRoot }
$RepoRoot = Split-Path -Parent $PSCommandPath | Split-Path -Parent

$script:PassCount = 0
$script:FailCount = 0
$script:WarnCount = 0

function Write-ArsenalHeader {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Blue
    Write-Host "  Claude Code Arsenal - Validator" -ForegroundColor Blue
    Write-Host "===============================================" -ForegroundColor Blue
    Write-Host ""
}

function Test-Pass { param([string]$Label) Write-Host "  PASS  $Label" -ForegroundColor Green; $script:PassCount++ }
function Test-Fail { param([string]$Label) Write-Host "  FAIL  $Label" -ForegroundColor Red;   $script:FailCount++ }
function Test-Warn { param([string]$Label) Write-Host "  WARN  $Label" -ForegroundColor Yellow; $script:WarnCount++ }
function Write-Section { param([string]$Title) Write-Host ""; Write-Host "-- $Title" -ForegroundColor Blue }

function Check-File {
    param([string]$Path, [string]$Label)
    if ([string]::IsNullOrEmpty($Label)) { $Label = $Path }
    if (Test-Path -Path $Path -PathType Leaf) { Test-Pass $Label } else { Test-Fail "$Label - file not found" }
}

function Check-Dir {
    param([string]$Path, [string]$Label)
    if ([string]::IsNullOrEmpty($Label)) { $Label = $Path }
    if (Test-Path -Path $Path -PathType Container) { Test-Pass $Label } else { Test-Fail "$Label - directory not found" }
}

function Check-Contains {
    param([string]$FilePath, [string]$Pattern, [string]$Label)
    if ((Test-Path -Path $FilePath -PathType Leaf) -and (Select-String -Path $FilePath -Pattern ([regex]::Escape($Pattern)) -Quiet -ErrorAction SilentlyContinue)) {
        Test-Pass $Label
    } else {
        Test-Fail $Label
    }
}

function Check-Xref {
    param([string]$SourcePath, [string]$Reference, [string]$Label)
    if ((Test-Path -Path $SourcePath -PathType Leaf) -and (Select-String -Path $SourcePath -Pattern ([regex]::Escape($Reference)) -Quiet -ErrorAction SilentlyContinue)) {
        Test-Pass $Label
    } else {
        Test-Warn "$Label - cross-reference not found"
    }
}

function Invoke-ValidateTarget {
    param([string]$Target)

    Write-ArsenalHeader
    Write-Host "  Validating: $Target" -ForegroundColor Blue

    # --- Core Files ---
    Write-Section "Core Files"
    Check-File (Join-Path $Target "CLAUDE.md") "CLAUDE.md"
    Check-File (Join-Path $Target "AGENTS.md") "AGENTS.md"

    # --- .claude/ Structure ---
    Write-Section ".claude/ Configuration"
    Check-File (Join-Path $Target ".claude\constitution.md") ".claude/constitution.md"
    Check-File (Join-Path $Target ".claude\settings.json")   ".claude/settings.json"

    # --- Agents ---
    Write-Section "Agents"
    Check-Dir (Join-Path $Target ".claude\agents") ".claude/agents/"
    foreach ($agent in @("orchestrator", "planner", "researcher", "fixer", "validator", "reviewer")) {
        Check-File (Join-Path $Target ".claude\agents\$agent.md") "$agent agent"
    }

    # --- Commands ---
    Write-Section "Commands"
    Check-Dir (Join-Path $Target ".claude\commands") ".claude/commands/"
    foreach ($cmd in @("triage-task", "plan-task", "fix-bug", "implement-feature", "debug-root-cause",
                        "validate-change", "review-diff", "review-architecture", "safety-review", "quality-gate")) {
        Check-File (Join-Path $Target ".claude\commands\$cmd.md") "$cmd command"
    }

    # --- Hooks ---
    Write-Section "Hooks"
    Check-Dir (Join-Path $Target ".claude\hooks") ".claude/hooks/"
    Check-File (Join-Path $Target ".claude\hooks\pre-commit.sh") "pre-commit hook"

    if (Test-Path (Join-Path $Target ".claude\hooks\pre-push.sh")) {
        Test-Pass "pre-push hook"
    } else {
        Test-Warn "pre-push hook - optional, not installed"
    }
    if (Test-Path (Join-Path $Target ".claude\hooks\post-task.sh")) {
        Test-Pass "post-task hook"
    } else {
        Test-Warn "post-task hook - optional, not installed"
    }

    # --- Templates ---
    Write-Section "Templates"
    Check-Dir (Join-Path $Target ".claude\templates") ".claude/templates/"
    Check-File (Join-Path $Target ".claude\templates\task-template.md") "task template"

    # --- Docs ---
    Write-Section "Documentation"
    Check-Dir (Join-Path $Target "docs") "docs/"
    foreach ($doc in @("workflow", "conventions", "checklists", "debugging", "verification", "decisions", "handoff", "preflight")) {
        Check-File (Join-Path $Target "docs\$doc.md") "$doc doc"
    }

    # --- Automation & Token Scripts ---
    Write-Section "Automation & Token Tools"
    if (Test-Path (Join-Path $Target "CLAUDE_COMPACT.md")) {
        Test-Pass "CLAUDE_COMPACT.md rules"
    } else {
        Test-Warn "CLAUDE_COMPACT.md - optional, token-optimized rules not found"
    }
    if (Test-Path (Join-Path $Target "scripts\log-filter.ps1")) {
        Test-Pass "log-filter.ps1 script"
    } else {
        Test-Warn "log-filter.ps1 - log filtering script not found"
    }
    if (Test-Path (Join-Path $Target "scripts\fast-check.ps1")) {
        Test-Pass "fast-check.ps1 script"
    } else {
        Test-Warn "fast-check.ps1 - fast check script not found"
    }
    if (Test-Path (Join-Path $Target "scripts\arsenal.ps1")) {
        Test-Pass "arsenal.ps1 CLI tool"
    } else {
        Test-Warn "arsenal.ps1 - unified CLI tool not found"
    }
    if (Test-Path (Join-Path $Target "scripts\validate.sh")) {
        Test-Pass "validate.sh script"
    } else {
        Test-Warn "validate.sh - bash validator not found"
    }

    # --- Cross-References ---
    Write-Section "Cross-References"
    Check-Xref (Join-Path $Target "CLAUDE.md") "AGENTS.md"   "CLAUDE.md -> AGENTS.md"
    Check-Xref (Join-Path $Target "AGENTS.md") "progress.md" "AGENTS.md -> progress.md"
    Check-Contains (Join-Path $Target ".claude\settings.json") '"deny"'   "settings.json has deny-list"
    Check-Contains (Join-Path $Target ".claude\constitution.md") "Principles" "constitution.md has principles"

    # --- Agent Contracts ---
    Write-Section "Agent Contract Integrity"
    foreach ($agent in @("orchestrator", "planner", "researcher", "fixer", "validator", "reviewer")) {
        $agentFile = Join-Path $Target ".claude\agents\$agent.md"
        if (Test-Path $agentFile) {
            Check-Contains $agentFile "Contract"   "$agent has contract"
            Check-Contains $agentFile "Guardrails" "$agent has guardrails"
            $firstLine = Get-Content $agentFile -TotalCount 1
            if ($firstLine -eq "---") {
                Test-Pass "$agent has subagent frontmatter"
            } else {
                Test-Fail "$agent missing frontmatter - not registered as a Task-invokable subagent"
            }
        }
    }

    # --- Command Structure ---
    Write-Section "Command Structure Integrity"
    $cmdDir = Join-Path $Target ".claude\commands"
    if (Test-Path $cmdDir) {
        Get-ChildItem -Path $cmdDir -Filter "*.md" -File | ForEach-Object {
            $cmdName = $_.BaseName
            Check-Contains $_.FullName "Protocol"   "$cmdName has protocol"
            Check-Contains $_.FullName "Guardrails" "$cmdName has guardrails"
        }
    }

    # --- Settings Safety ---
    Write-Section "Settings Safety"
    $settingsFile = Join-Path $Target ".claude\settings.json"
    Check-Contains $settingsFile "rm -rf"      "Denies rm -rf /"
    Check-Contains $settingsFile "sudo"        "Denies sudo"
    Check-Contains $settingsFile "force"       "Denies force push"
    Check-Contains $settingsFile "autoApprove" "Has autoApprove setting"

    # --- Results ---
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Blue
    $summary = "  Results: $script:PassCount passed"
    if ($script:FailCount -gt 0) { $summary += ", $script:FailCount failed" }
    if ($script:WarnCount -gt 0) { $summary += ", $script:WarnCount warnings" }
    Write-Host $summary
    Write-Host "===============================================" -ForegroundColor Blue
    Write-Host ""

    if ($script:FailCount -gt 0) {
        exit 1
    }
}

# --- Main ---

if ($Self) {
    Invoke-ValidateTarget -Target $RepoRoot
} elseif ([string]::IsNullOrEmpty($TargetPath)) {
    Write-Host "Error: No target specified."
    Write-Host "Usage: .\scripts\validate.ps1 -TargetPath C:\path\to\project"
    Write-Host "   or: .\scripts\validate.ps1 -Self"
    exit 1
} else {
    Invoke-ValidateTarget -Target $TargetPath
}
