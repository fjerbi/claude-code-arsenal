#!/usr/bin/env bash
# Claude Code Arsenal — Log Filter
# Runs a command and filters output to retain only errors, failures, and stack traces.
# Saves LLM token context by stripping verbose success lines.
#
# Usage:
#   bash scripts/log-filter.sh "npm test"
#   bash scripts/log-filter.sh "pytest"
#   cat test.log | bash scripts/log-filter.sh

set -euo pipefail

FILTER_PATTERNS="(FAIL|ERROR|Error|FAILED|Exception|Traceback|AssertionError|panic:|fatal:|\[ERROR\]|\[FAIL\])"

run_and_filter() {
  local temp_out
  temp_out="$(mktemp)"
  
  # Run command and capture exit code
  set +e
  "$@" > "$temp_out" 2>&1
  local exit_code=$?
  set -e

  if [[ $exit_code -eq 0 ]]; then
    echo "✓ Command succeeded ($(basename "$1")). Log summary:"
    grep -i -E "(pass|passed|success|ok|completed)" "$temp_out" | tail -n 10 || echo "Done."
  else
    echo "✗ Command failed (exit code $exit_code). Filtered output:"
    echo "--------------------------------------------------------"
    if grep -q -i -E "$FILTER_PATTERNS" "$temp_out"; then
      grep -i -E "$FILTER_PATTERNS" -A 15 -B 3 "$temp_out" | head -n 100
    else
      tail -n 40 "$temp_out"
    fi
    echo "--------------------------------------------------------"
  fi

  rm -f "$temp_out"
  return $exit_code
}

filter_stdin() {
  local temp_out
  temp_out="$(mktemp)"
  cat > "$temp_out"

  if grep -q -i -E "$FILTER_PATTERNS" "$temp_out"; then
    grep -i -E "$FILTER_PATTERNS" -A 15 -B 3 "$temp_out" | head -n 100
  else
    tail -n 40 "$temp_out"
  fi

  rm -f "$temp_out"
}

if [[ $# -gt 0 ]]; then
  run_and_filter "$@"
elif [[ ! -t 0 ]]; then
  filter_stdin
else
  echo "Usage: bash scripts/log-filter.sh <command...>"
  echo "   or: command | bash scripts/log-filter.sh"
  exit 1
fi
