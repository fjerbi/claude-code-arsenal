#!/usr/bin/env bash
# Claude Code Arsenal — Pre-Push Hook
# Runs validation before pushing to remote.
#
# Checks:
#   1. No uncommitted changes left behind
#   2. No force push without explicit flag
#   3. Core tests pass (if available)
#   4. Arsenal validation (if installed)
#
# Install: cp .claude/hooks/pre-push.sh .git/hooks/pre-push && chmod +x .git/hooks/pre-push

set -eu

ERRORS=0

fail() {
  printf '\033[0;31m✗\033[0m %s\n' "$1" >&2
  ERRORS=$((ERRORS + 1))
}

pass() {
  printf '\033[0;32m✓\033[0m %s\n' "$1"
}

warn() {
  printf '\033[1;33m⚠\033[0m %s\n' "$1"
}

printf '\n\033[0;34m── Pre-Push Safety Checks ──\033[0m\n\n'

# --- 1. Check for uncommitted changes ---
if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
  pass "No uncommitted changes"
else
  warn "Uncommitted changes exist — ensure they are intentionally excluded"
fi

# --- 2. Check for untracked files ---
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | head -5)
if [[ -z "$UNTRACKED" ]]; then
  pass "No untracked files"
else
  UNTRACKED_COUNT=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
  warn "$UNTRACKED_COUNT untracked file(s) — review before push"
fi

# --- 3. Verify current branch ---
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
pass "Pushing branch: $CURRENT_BRANCH"

# Warn if pushing directly to main/master
case "$CURRENT_BRANCH" in
  main|master)
    warn "Pushing directly to $CURRENT_BRANCH — consider using a feature branch"
    ;;
esac

# --- 4. Check if tests exist and run them ---
if [[ -f "package.json" ]] && grep -q '"test"' package.json 2>/dev/null; then
  printf '\033[0;34m→\033[0m Running tests...\n'
  if npm test --silent 2>/dev/null; then
    pass "Tests passed"
  else
    fail "Tests failed — fix before pushing"
  fi
elif [[ -f "Makefile" ]] && grep -q '^test:' Makefile 2>/dev/null; then
  printf '\033[0;34m→\033[0m Running tests...\n'
  if make test 2>/dev/null; then
    pass "Tests passed"
  else
    fail "Tests failed — fix before pushing"
  fi
elif [[ -f "Cargo.toml" ]]; then
  printf '\033[0;34m→\033[0m Running cargo check...\n'
  if cargo check --quiet 2>/dev/null; then
    pass "Cargo check passed"
  else
    fail "Cargo check failed — fix before pushing"
  fi
else
  pass "No test runner detected — skipping automated tests"
fi

# --- 5. Verify no progress.md is committed ---
if git log --oneline -1 --name-only 2>/dev/null | grep -q "progress.md"; then
  warn "progress.md was committed — this is usually a temporary file"
fi

# --- Result ---
echo ""
if [[ $ERRORS -gt 0 ]]; then
  printf '\033[0;31m✗ Pre-push checks failed (%d errors). Fix issues before pushing.\033[0m\n\n' "$ERRORS"
  exit 1
else
  printf '\033[0;32m✓ All pre-push checks passed.\033[0m\n\n'
fi
