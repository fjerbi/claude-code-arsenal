#!/usr/bin/env bash
# Claude Code Arsenal — Install Script
# Copies Arsenal files into a target project or global Claude Code config.
#
# Usage:
#   bash scripts/install.sh /path/to/project    # Project-level install
#   bash scripts/install.sh --global             # Global install
#   bash scripts/install.sh --help               # Show help
#
# Idempotent: safe to re-run. Existing CLAUDE.md is backed up, not overwritten.

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ARSENAL_VERSION="1.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
  printf '\n%b═══════════════════════════════════════════════%b\n' "$BLUE" "$NC"
  printf '%b  Claude Code Arsenal — Installer v%s%b\n' "$BLUE" "$ARSENAL_VERSION" "$NC"
  printf '%b═══════════════════════════════════════════════%b\n\n' "$BLUE" "$NC"
}

print_success() { printf '%b✓%b %s\n' "$GREEN" "$NC" "$1"; }
print_warning() { printf '%b⚠%b %s\n' "$YELLOW" "$NC" "$1"; }
print_error()   { printf '%b✗%b %s\n' "$RED" "$NC" "$1"; }
print_info()    { printf '%b→%b %s\n' "$BLUE" "$NC" "$1"; }

show_help() {
  cat <<EOF
Claude Code Arsenal — Installer

Usage:
  bash scripts/install.sh <target-path>    Install into a specific project
  bash scripts/install.sh --global         Install globally for all projects
  bash scripts/install.sh --help           Show this help

Options:
  <target-path>   Path to the project root where Arsenal will be installed.
  --global        Install to Claude Code user-level config (~/.claude/).
  --force         Overwrite existing CLAUDE.md without backup.
  --no-hooks      Skip installing git hooks.
  --help          Show this help message.

What gets installed:
  Project-level:
    CLAUDE.md               Core operating instructions
    AGENTS.md               Multi-agent execution model
    .claude/constitution.md Immutable principles
    .claude/settings.json   Project settings & safety deny-list
    .claude/agents/         Specialized agent definitions (6 agents)
    .claude/commands/       Workflow commands (10 commands)
    .claude/hooks/          Safety hooks (3 hooks)
    .claude/templates/      Reusable templates (4 templates)
    docs/                   Extended documentation (8 docs)

  Global:
    CLAUDE.md               Core operating instructions only

EOF
}

# Resolve global config directory
get_global_dir() {
  if [[ -n "${CLAUDE_CONFIG_DIR:-}" ]]; then
    echo "$CLAUDE_CONFIG_DIR"
  elif [[ -d "$HOME/.claude" ]]; then
    echo "$HOME/.claude"
  else
    echo "$HOME/.claude"
  fi
}

# Copy a file, creating parent directories as needed
install_file() {
  local src="$1"
  local dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  if [[ ! -d "$dst_dir" ]]; then
    mkdir -p "$dst_dir"
  fi

  cp "$src" "$dst"
  print_success "Installed $(basename "$dst")"
}

# Back up a file if it exists and isn't identical
backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup="${file}.arsenal-backup.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup"
    print_warning "Backed up existing $(basename "$file") → $(basename "$backup")"
  fi
}

# Install into a specific project
install_project() {
  local target="$1"
  local force="${2:-false}"
  local no_hooks="${3:-false}"

  if [[ ! -d "$target" ]]; then
    print_error "Target directory does not exist: $target"
    exit 1
  fi

  print_info "Installing Arsenal into: $target"
  echo ""

  # CLAUDE.md & CLAUDE_COMPACT.md — back up if exists (unless --force)
  if [[ -f "$target/CLAUDE.md" && "$force" != "true" ]]; then
    backup_file "$target/CLAUDE.md"
  fi
  install_file "$SCRIPT_DIR/CLAUDE.md" "$target/CLAUDE.md"
  if [[ -f "$SCRIPT_DIR/CLAUDE_COMPACT.md" ]]; then
    install_file "$SCRIPT_DIR/CLAUDE_COMPACT.md" "$target/CLAUDE_COMPACT.md"
  fi

  # AGENTS.md
  if [[ -f "$target/AGENTS.md" && "$force" != "true" ]]; then
    backup_file "$target/AGENTS.md"
  fi
  install_file "$SCRIPT_DIR/AGENTS.md" "$target/AGENTS.md"

  # .claude/ directory
  print_info "Installing .claude/ configuration..."
  install_file "$SCRIPT_DIR/.claude/constitution.md" "$target/.claude/constitution.md"
  install_file "$SCRIPT_DIR/.claude/settings.json"   "$target/.claude/settings.json"

  # Agents
  print_info "Installing agents..."
  for agent in "$SCRIPT_DIR"/.claude/agents/*.md; do
    install_file "$agent" "$target/.claude/agents/$(basename "$agent")"
  done

  # Commands
  print_info "Installing commands..."
  for cmd in "$SCRIPT_DIR"/.claude/commands/*.md; do
    install_file "$cmd" "$target/.claude/commands/$(basename "$cmd")"
  done

  # Hooks
  if [[ "$no_hooks" != "true" ]]; then
    print_info "Installing hooks..."
    for hook in "$SCRIPT_DIR"/.claude/hooks/*.sh; do
      install_file "$hook" "$target/.claude/hooks/$(basename "$hook")"
      chmod +x "$target/.claude/hooks/$(basename "$hook")"
    done

    # Auto-wire git hooks if .git directory exists
    if [[ -d "$target/.git" ]]; then
      print_info "Wiring Git hooks into $target/.git/hooks/..."
      mkdir -p "$target/.git/hooks"
      if [[ -f "$target/.claude/hooks/pre-commit.sh" ]]; then
        cp "$target/.claude/hooks/pre-commit.sh" "$target/.git/hooks/pre-commit"
        chmod +x "$target/.git/hooks/pre-commit"
        print_success "Auto-wired Git pre-commit hook"
      fi
      if [[ -f "$target/.claude/hooks/pre-push.sh" ]]; then
        cp "$target/.claude/hooks/pre-push.sh" "$target/.git/hooks/pre-push"
        chmod +x "$target/.git/hooks/pre-push"
        print_success "Auto-wired Git pre-push hook"
      fi
    fi
  else
    print_warning "Skipping hooks (--no-hooks)"
  fi

  # Scripts
  print_info "Installing automation scripts..."
  for scr in "$SCRIPT_DIR"/scripts/*.sh "$SCRIPT_DIR"/scripts/*.ps1; do
    if [[ -f "$scr" ]]; then
      install_file "$scr" "$target/scripts/$(basename "$scr")"
      if [[ "$scr" == *.sh ]]; then
        chmod +x "$target/scripts/$(basename "$scr")"
      fi
    fi
  done

  # Templates
  print_info "Installing templates..."
  for tmpl in "$SCRIPT_DIR"/.claude/templates/*.md; do
    install_file "$tmpl" "$target/.claude/templates/$(basename "$tmpl")"
  done

  # Docs
  print_info "Installing documentation..."
  for doc in "$SCRIPT_DIR"/docs/*.md; do
    install_file "$doc" "$target/docs/$(basename "$doc")"
  done

  echo ""
  print_success "Arsenal v${ARSENAL_VERSION} installed successfully!"
  echo ""
  print_info "Next steps:"
  echo "  1. Review CLAUDE.md and customize for your project"
  echo "  2. Review .claude/settings.json and adjust permissions"
  echo "  3. Run: bash scripts/validate.sh $target"
  echo ""
}

# Install globally
install_global() {
  local global_dir
  global_dir="$(get_global_dir)"

  print_info "Installing Arsenal globally to: $global_dir"
  echo ""

  mkdir -p "$global_dir"

  if [[ -f "$global_dir/CLAUDE.md" ]]; then
    backup_file "$global_dir/CLAUDE.md"
  fi

  install_file "$SCRIPT_DIR/CLAUDE.md" "$global_dir/CLAUDE.md"
  install_file "$SCRIPT_DIR/.claude/constitution.md" "$global_dir/constitution.md"

  echo ""
  print_success "Arsenal installed globally!"
  print_info "Core rules will apply to all projects using Claude Code."
  echo ""
}

# --- Main ---

print_header

FORCE=false
GLOBAL=false
NO_HOOKS=false
TARGET=""

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      show_help
      exit 0
      ;;
    --global)
      GLOBAL=true
      ;;
    --force)
      FORCE=true
      ;;
    --no-hooks)
      NO_HOOKS=true
      ;;
    *)
      TARGET="$arg"
      ;;
  esac
done

if [[ "$GLOBAL" == "true" ]]; then
  install_global
elif [[ -n "$TARGET" ]]; then
  install_project "$TARGET" "$FORCE" "$NO_HOOKS"
else
  print_error "No target specified."
  echo ""
  echo "Usage:"
  echo "  bash scripts/install.sh /path/to/project"
  echo "  bash scripts/install.sh --global"
  echo "  bash scripts/install.sh --help"
  exit 1
fi
