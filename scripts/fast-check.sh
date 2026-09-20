#!/usr/bin/env bash
# Claude Code Arsenal — Instant Pre-Flight Fast Check
# Performs deterministic local checks in <300ms.
# Replaces sequential multi-step LLM tool calls.
#
# Usage:
#   bash scripts/fast-check.sh [path]

set -euo pipefail

TARGET="${1:-.}"
ERRORS=0
WARNINGS=0

echo "🔍 Arsenal Fast Check Target: $TARGET"

# 1. Check .claude/settings.json validity
if [[ -f "$TARGET/.claude/settings.json" ]]; then
  if command -v jq > /dev/null 2>&1; then
    JSON_CHECK="jq ."
  elif command -v node > /dev/null 2>&1; then
    JSON_CHECK="node -e \"JSON.parse(require('fs').readFileSync(process.argv[1],'utf8'))\""
  elif python3 -c "" > /dev/null 2>&1; then
    JSON_CHECK="python3 -m json.tool"
  else
    JSON_CHECK=""
  fi

  if [[ -z "$JSON_CHECK" ]]; then
    echo "⚠ WARN: no jq/node/python3 available — skipping settings.json validation"
    WARNINGS=$((WARNINGS + 1))
  elif eval "$JSON_CHECK" "$TARGET/.claude/settings.json" > /dev/null 2>&1; then
    echo "✓ Settings JSON valid"
  else
    echo "✗ ERROR: .claude/settings.json contains invalid JSON"
    ERRORS=$((ERRORS + 1))
  fi
fi

# 2. Check shell scripts for syntax errors
SH_COUNT=0
for shfile in "$TARGET"/*.sh "$TARGET"/scripts/*.sh "$TARGET"/.claude/hooks/*.sh; do
  if [[ -f "$shfile" ]]; then
    SH_COUNT=$((SH_COUNT + 1))
    if ! bash -n "$shfile" 2>/dev/null; then
      echo "✗ ERROR: Syntax error in $shfile"
      ERRORS=$((ERRORS + 1))
    fi
  fi
done
echo "✓ Shell syntax verified across $SH_COUNT files"

# 3. Check for conflict markers
if grep -rn "^<<<<<<< " --exclude-dir=".git" "$TARGET" > /dev/null 2>&1; then
  echo "✗ ERROR: Git merge conflict markers found!"
  ERRORS=$((ERRORS + 1))
else
  echo "✓ No git merge conflict markers found"
fi

# Summary Output
echo "--------------------------------------------------------"
if [[ $ERRORS -eq 0 ]]; then
  echo "STATUS: PASS (Errors: 0, Warnings: $WARNINGS)"
  exit 0
else
  echo "STATUS: FAIL (Errors: $ERRORS, Warnings: $WARNINGS)"
  exit 1
fi
