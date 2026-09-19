#!/usr/bin/env bash
# Claude Code Arsenal — Validation Script
# Validates that an Arsenal installation is complete and consistent.
#
# Usage:
#   bash scripts/validate.sh /path/to/project    # Validate a project install
#   bash scripts/validate.sh .                    # Validate current directory
#   bash scripts/validate.sh --self               # Validate the Arsenal repo itself
#
# Exit codes:
#   0 — All checks passed
#   1 — One or more checks failed

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

print_header() {
  printf '\n%b═══════════════════════════════════════════════%b\n' "$BLUE" "$NC"
  printf '%b  Claude Code Arsenal — Validator%b\n' "$BLUE" "$NC"
  printf '%b═══════════════════════════════════════════════%b\n\n' "$BLUE" "$NC"
}

pass()    { printf '%b  PASS%b  %s\n' "$GREEN" "$NC" "$1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail()    { printf '%b  FAIL%b  %s\n' "$RED" "$NC" "$1";   FAIL_COUNT=$((FAIL_COUNT + 1)); }
warn()    { printf '%b  WARN%b  %s\n' "$YELLOW" "$NC" "$1"; WARN_COUNT=$((WARN_COUNT + 1)); }
section() { printf '\n%b── %s%b\n' "$BLUE" "$1" "$NC"; }

# Check if a file exists
check_file() {
  local path="$1"
  local label="${2:-$path}"
  if [[ -f "$path" ]]; then
    pass "$label"
  else
    fail "$label — file not found"
  fi
}

# Check if a directory exists
check_dir() {
  local path="$1"
  local label="${2:-$path}"
  if [[ -d "$path" ]]; then
    pass "$label"
  else
    fail "$label — directory not found"
  fi
}

# Check if file contains a specific string
check_contains() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if [[ -f "$file" ]] && grep -q "$pattern" "$file" 2>/dev/null; then
    pass "$label"
  else
    fail "$label"
  fi
}

# Check cross-reference: file A mentions file B
check_xref() {
  local source="$1"
  local reference="$2"
  local label="$3"
  if [[ -f "$source" ]] && grep -q "$reference" "$source" 2>/dev/null; then
    pass "$label"
  else
    warn "$label — cross-reference not found"
  fi
}

validate_target() {
  local target="$1"

  print_header
  printf '%b  Validating: %s%b\n' "$BLUE" "$target" "$NC"

  # --- Core Files ---
  section "Core Files"
  check_file "$target/CLAUDE.md"   "CLAUDE.md"
  check_file "$target/AGENTS.md"   "AGENTS.md"

  # --- .claude/ Structure ---
  section ".claude/ Configuration"
  check_file "$target/.claude/constitution.md"   ".claude/constitution.md"
  check_file "$target/.claude/settings.json"     ".claude/settings.json"

  # --- Agents ---
  section "Agents"
  check_dir  "$target/.claude/agents"              ".claude/agents/"
  check_file "$target/.claude/agents/orchestrator.md" "orchestrator agent"
  check_file "$target/.claude/agents/planner.md"      "planner agent"
  check_file "$target/.claude/agents/researcher.md"   "researcher agent"
  check_file "$target/.claude/agents/fixer.md"        "fixer agent"
  check_file "$target/.claude/agents/validator.md"    "validator agent"
  check_file "$target/.claude/agents/reviewer.md"     "reviewer agent"

  # --- Commands ---
  section "Commands"
  check_dir  "$target/.claude/commands"                     ".claude/commands/"
  check_file "$target/.claude/commands/triage-task.md"      "triage-task command"
  check_file "$target/.claude/commands/plan-task.md"        "plan-task command"
  check_file "$target/.claude/commands/fix-bug.md"          "fix-bug command"
  check_file "$target/.claude/commands/implement-feature.md" "implement-feature command"
  check_file "$target/.claude/commands/debug-root-cause.md" "debug-root-cause command"
  check_file "$target/.claude/commands/validate-change.md"  "validate-change command"
  check_file "$target/.claude/commands/review-diff.md"      "review-diff command"
  check_file "$target/.claude/commands/review-architecture.md" "review-architecture command"
  check_file "$target/.claude/commands/safety-review.md"    "safety-review command"
  check_file "$target/.claude/commands/quality-gate.md"     "quality-gate command"

  # --- Hooks ---
  section "Hooks"
  check_dir  "$target/.claude/hooks"               ".claude/hooks/"
  check_file "$target/.claude/hooks/pre-commit.sh" "pre-commit hook"

  # Optional hooks (warn if missing, don't fail)
  if [[ -f "$target/.claude/hooks/pre-push.sh" ]]; then
    pass "pre-push hook"
  else
    warn "pre-push hook — optional, not installed"
  fi
  if [[ -f "$target/.claude/hooks/post-task.sh" ]]; then
    pass "post-task hook"
  else
    warn "post-task hook — optional, not installed"
  fi

  # --- Templates ---
  section "Templates"
  check_dir  "$target/.claude/templates"                   ".claude/templates/"
  check_file "$target/.claude/templates/task-template.md"  "task template"

  # --- Docs ---
  section "Documentation"
  check_dir  "$target/docs"                    "docs/"
  check_file "$target/docs/workflow.md"        "workflow doc"
  check_file "$target/docs/conventions.md"     "conventions doc"
  check_file "$target/docs/checklists.md"      "checklists doc"
  check_file "$target/docs/debugging.md"       "debugging doc"
  check_file "$target/docs/verification.md"    "verification doc"
  check_file "$target/docs/decisions.md"       "decisions doc"
  check_file "$target/docs/handoff.md"         "handoff doc"
  check_file "$target/docs/preflight.md"       "preflight doc"

  # --- Cross-References ---
  section "Cross-References"
  check_xref "$target/CLAUDE.md" "AGENTS.md"      "CLAUDE.md → AGENTS.md"
  check_xref "$target/AGENTS.md" "progress.md"    "AGENTS.md → progress.md"
  check_contains "$target/.claude/settings.json" '"deny"' "settings.json has deny-list"
  check_contains "$target/.claude/constitution.md" "Principles" "constitution.md has principles"

  # --- Agent Contracts ---
  section "Agent Contract Integrity"
  for agent in orchestrator planner researcher fixer validator reviewer; do
    local agent_file="$target/.claude/agents/${agent}.md"
    if [[ -f "$agent_file" ]]; then
      check_contains "$agent_file" "Contract"   "${agent} has contract"
      check_contains "$agent_file" "Guardrails" "${agent} has guardrails"
    fi
  done

  # --- Command Structure ---
  section "Command Structure Integrity"
  for cmd in "$target"/.claude/commands/*.md; do
    if [[ -f "$cmd" ]]; then
      local cmd_name
      cmd_name="$(basename "$cmd" .md)"
      check_contains "$cmd" "Protocol"   "${cmd_name} has protocol"
      check_contains "$cmd" "Guardrails" "${cmd_name} has guardrails"
    fi
  done

  # --- Settings Safety ---
  section "Settings Safety"
  check_contains "$target/.claude/settings.json" "rm -rf"        "Denies rm -rf /"
  check_contains "$target/.claude/settings.json" "sudo"          "Denies sudo"
  check_contains "$target/.claude/settings.json" "force"         "Denies force push"
  check_contains "$target/.claude/settings.json" "autoApprove"   "Has autoApprove setting"

  # --- Results ---
  printf '\n%b═══════════════════════════════════════════════%b\n' "$BLUE" "$NC"
  printf '  Results: %b%d passed%b' "$GREEN" "$PASS_COUNT" "$NC"
  if [[ $FAIL_COUNT -gt 0 ]]; then
    printf ', %b%d failed%b' "$RED" "$FAIL_COUNT" "$NC"
  fi
  if [[ $WARN_COUNT -gt 0 ]]; then
    printf ', %b%d warnings%b' "$YELLOW" "$WARN_COUNT" "$NC"
  fi
  printf '\n%b═══════════════════════════════════════════════%b\n\n' "$BLUE" "$NC"

  if [[ $FAIL_COUNT -gt 0 ]]; then
    exit 1
  fi
}

# --- Main ---

case "${1:-}" in
  --help|-h)
    echo "Usage:"
    echo "  bash scripts/validate.sh /path/to/project"
    echo "  bash scripts/validate.sh ."
    echo "  bash scripts/validate.sh --self"
    exit 0
    ;;
  --self)
    validate_target "$SCRIPT_DIR"
    ;;
  "")
    echo "Error: No target specified."
    echo "Usage: bash scripts/validate.sh /path/to/project"
    exit 1
    ;;
  *)
    validate_target "$1"
    ;;
esac
