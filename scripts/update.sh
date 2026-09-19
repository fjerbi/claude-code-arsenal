#!/usr/bin/env bash
# Claude Code Arsenal — Update Script
# Updates an existing Arsenal installation to the latest version.
#
# Usage:
#   bash scripts/update.sh /path/to/project
#
# Backs up customized files before overwriting. Safe to re-run.

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ARSENAL_VERSION="1.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
  printf '\n%b═══════════════════════════════════════════════%b\n' "$BLUE" "$NC"
  printf '%b  Claude Code Arsenal — Updater v%s%b\n' "$BLUE" "$ARSENAL_VERSION" "$NC"
  printf '%b═══════════════════════════════════════════════%b\n\n' "$BLUE" "$NC"
}

print_success() { printf '%b✓%b %s\n' "$GREEN" "$NC" "$1"; }
print_warning() { printf '%b⚠%b %s\n' "$YELLOW" "$NC" "$1"; }
print_error()   { printf '%b✗%b %s\n' "$RED" "$NC" "$1"; }
print_info()    { printf '%b→%b %s\n' "$BLUE" "$NC" "$1"; }

show_help() {
  cat <<EOF
Claude Code Arsenal — Updater

Usage:
  bash scripts/update.sh <target-path>     Update Arsenal in a project
  bash scripts/update.sh --help            Show help

What happens:
  1. Backs up your existing CLAUDE.md and AGENTS.md
  2. Copies latest Arsenal files over existing installation
  3. Preserves your .claude/settings.json (backed up, not overwritten)
  4. Reports what was updated

After update:
  - Review backed-up files for custom changes you want to re-apply
  - Run: bash scripts/validate.sh <target-path>

EOF
}

# Files that should be backed up before overwriting (user may have customized them)
readonly CUSTOMIZABLE_FILES=(
  "CLAUDE.md"
  "AGENTS.md"
  ".claude/settings.json"
)

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup="${file}.pre-update.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup"
    print_warning "Backed up $(basename "$file")"
  fi
}

update_file() {
  local src="$1"
  local dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  mkdir -p "$dst_dir"

  if [[ -f "$dst" ]]; then
    # Check if file has changed
    if diff -q "$src" "$dst" > /dev/null 2>&1; then
      printf '  %b·%b %s (unchanged)\n' "$BLUE" "$NC" "$(basename "$dst")"
      return
    fi
  fi

  cp "$src" "$dst"
  print_success "Updated $(basename "$dst")"
}

update_project() {
  local target="$1"

  if [[ ! -d "$target" ]]; then
    print_error "Target directory does not exist: $target"
    exit 1
  fi

  if [[ ! -f "$target/CLAUDE.md" ]]; then
    print_error "No Arsenal installation found in $target"
    print_info "Run install.sh first: bash scripts/install.sh $target"
    exit 1
  fi

  print_info "Updating Arsenal in: $target"
  echo ""

  # Backup customizable files
  print_info "Backing up customizable files..."
  for cf in "${CUSTOMIZABLE_FILES[@]}"; do
    backup_file "$target/$cf"
  done
  echo ""

  # Update core files
  print_info "Updating core files..."
  update_file "$SCRIPT_DIR/CLAUDE.md"  "$target/CLAUDE.md"
  update_file "$SCRIPT_DIR/AGENTS.md"  "$target/AGENTS.md"
  echo ""

  # Update .claude/ config
  print_info "Updating .claude/ configuration..."
  update_file "$SCRIPT_DIR/.claude/constitution.md" "$target/.claude/constitution.md"
  update_file "$SCRIPT_DIR/.claude/settings.json"   "$target/.claude/settings.json"
  echo ""

  # Update agents
  print_info "Updating agents..."
  for agent in "$SCRIPT_DIR"/.claude/agents/*.md; do
    update_file "$agent" "$target/.claude/agents/$(basename "$agent")"
  done
  echo ""

  # Update commands
  print_info "Updating commands..."
  for cmd in "$SCRIPT_DIR"/.claude/commands/*.md; do
    update_file "$cmd" "$target/.claude/commands/$(basename "$cmd")"
  done
  echo ""

  # Update hooks
  print_info "Updating hooks..."
  for hook in "$SCRIPT_DIR"/.claude/hooks/*.sh; do
    update_file "$hook" "$target/.claude/hooks/$(basename "$hook")"
    chmod +x "$target/.claude/hooks/$(basename "$hook")"
  done
  echo ""

  # Update templates
  print_info "Updating templates..."
  for tmpl in "$SCRIPT_DIR"/.claude/templates/*.md; do
    update_file "$tmpl" "$target/.claude/templates/$(basename "$tmpl")"
  done
  echo ""

  # Update docs
  print_info "Updating documentation..."
  for doc in "$SCRIPT_DIR"/docs/*.md; do
    update_file "$doc" "$target/docs/$(basename "$doc")"
  done

  echo ""
  print_success "Arsenal updated to v${ARSENAL_VERSION}!"
  echo ""
  print_info "Review your backed-up files for custom changes to re-apply."
  print_info "Run: bash scripts/validate.sh $target"
  echo ""
}

# --- Main ---

print_header

case "${1:-}" in
  --help|-h)
    show_help
    exit 0
    ;;
  "")
    print_error "No target specified."
    echo ""
    echo "Usage: bash scripts/update.sh /path/to/project"
    exit 1
    ;;
  *)
    update_project "$1"
    ;;
esac
