#!/usr/bin/env bash
# Claude Code Arsenal — Unified Command-Line Tool
# Usage:
#   bash scripts/arsenal.sh install [target]
#   bash scripts/arsenal.sh validate [target]
#   bash scripts/arsenal.sh check [target]
#   bash scripts/arsenal.sh filter "npm test"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_usage() {
  cat <<EOF
Claude Code Arsenal — Unified CLI Utility

Commands:
  install [target]   Install Arsenal into a target project directory
  validate [target]  Run full validation on an Arsenal installation
  check [target]     Run instant sub-second local pre-flight checks
  filter <command>   Run command with output log filtering to save tokens
  help               Display this help message

Examples:
  bash scripts/arsenal.sh check .
  bash scripts/arsenal.sh validate /path/to/project
  bash scripts/arsenal.sh filter "pytest"
EOF
}

COMMAND="${1:-help}"
shift || true

case "$COMMAND" in
  install)
    bash "$SCRIPT_DIR/install.sh" "$@"
    ;;
  validate)
    bash "$SCRIPT_DIR/validate.sh" "$@"
    ;;
  check)
    bash "$SCRIPT_DIR/fast-check.sh" "$@"
    ;;
  filter)
    bash "$SCRIPT_DIR/log-filter.sh" "$@"
    ;;
  help|--help|-h)
    show_usage
    ;;
  *)
    echo "Unknown command: $COMMAND"
    show_usage
    exit 1
    ;;
esac
