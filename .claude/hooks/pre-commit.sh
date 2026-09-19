#!/usr/bin/env bash
# Claude Code Arsenal — Pre-Commit Hook
# Runs safety checks before every commit.
#
# Checks:
#   1. Whitespace and merge-marker issues
#   2. Secret/credential detection
#   3. Debug artifact detection
#   4. Large file detection
#
# Install: cp .claude/hooks/pre-commit.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

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

printf '\n\033[0;34m── Pre-Commit Safety Checks ──\033[0m\n\n'

# --- 1. Whitespace and merge markers ---
if git diff --cached --check --quiet 2>/dev/null; then
  pass "No whitespace or merge-marker issues"
else
  fail "Whitespace or merge-marker issues detected"
  git diff --cached --check 2>/dev/null || true
fi

# --- 2. Secret / credential detection ---
# Patterns that suggest secrets in staged files
SECRET_PATTERNS=(
  'AKIA[0-9A-Z]{16}'                          # AWS Access Key
  'AIza[0-9A-Za-z\-_]{35}'                    # Google API Key
  'sk-[0-9a-zA-Z]{20,}'                       # OpenAI / Stripe secret key
  'ghp_[0-9a-zA-Z]{36}'                       # GitHub PAT
  'glpat-[0-9a-zA-Z\-_]{20,}'                 # GitLab PAT
  'xox[bpors]-[0-9a-zA-Z\-]{10,}'             # Slack token
  'sk_live_[0-9a-zA-Z]{24,}'                  # Stripe live key
  'rk_live_[0-9a-zA-Z]{24,}'                  # Stripe restricted key
  'SG\.[0-9A-Za-z\-_]{22}\.[0-9A-Za-z\-_]{43}' # SendGrid
  'key-[0-9a-zA-Z]{32}'                       # Generic API key
  '-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----' # Private keys
)

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)
SECRET_FOUND=false

if [[ -n "$STAGED_FILES" ]]; then
  for pattern in "${SECRET_PATTERNS[@]}"; do
    while IFS= read -r file; do
      # Skip binary files and common false-positive locations
      case "$file" in
        *.lock|*.min.js|*.min.css|*.map|*.woff*|*.ttf|*.eot|*.ico|*.png|*.jpg|*.gif|*.svg)
          continue
          ;;
      esac

      if git diff --cached -- "$file" 2>/dev/null | grep -qE "$pattern"; then
        fail "Possible secret in: $file (pattern: ${pattern:0:20}...)"
        SECRET_FOUND=true
      fi
    done <<< "$STAGED_FILES"
  done

  if [[ "$SECRET_FOUND" == "false" ]]; then
    pass "No secrets or credentials detected"
  fi
fi

# --- 3. Debug artifact detection ---
DEBUG_PATTERNS=(
  'console\.log'
  'debugger;'
  'binding\.pry'
  'import pdb'
  'pdb\.set_trace'
  'breakpoint()'
  'print("DEBUG'
  "print('DEBUG"
  'TODO REMOVE'
  'FIXME REMOVE'
  'HACK REMOVE'
)

DEBUG_FOUND=false

if [[ -n "$STAGED_FILES" ]]; then
  for pattern in "${DEBUG_PATTERNS[@]}"; do
    while IFS= read -r file; do
      case "$file" in
        *.lock|*.min.js|*.min.css|*.map|*.md|*.txt)
          continue
          ;;
      esac

      if git diff --cached -- "$file" 2>/dev/null | grep -q "^+" | head -1 && \
         git diff --cached -- "$file" 2>/dev/null | grep "^+" | grep -qF "$pattern"; then
        warn "Debug artifact in: $file ($pattern)"
        DEBUG_FOUND=true
      fi
    done <<< "$STAGED_FILES"
  done

  if [[ "$DEBUG_FOUND" == "false" ]]; then
    pass "No debug artifacts detected"
  fi
fi

# --- 4. Large file detection (>1MB) ---
LARGE_FILE_LIMIT=1048576  # 1MB in bytes
LARGE_FOUND=false

if [[ -n "$STAGED_FILES" ]]; then
  while IFS= read -r file; do
    if [[ -f "$file" ]]; then
      file_size=$(wc -c < "$file" 2>/dev/null || echo 0)
      if [[ $file_size -gt $LARGE_FILE_LIMIT ]]; then
        warn "Large file ($(( file_size / 1024 ))KB): $file"
        LARGE_FOUND=true
      fi
    fi
  done <<< "$STAGED_FILES"

  if [[ "$LARGE_FOUND" == "false" ]]; then
    pass "No large files (>1MB) detected"
  fi
fi

# --- Result ---
echo ""
if [[ $ERRORS -gt 0 ]]; then
  printf '\033[0;31m✗ Pre-commit checks failed (%d errors). Fix issues before committing.\033[0m\n\n' "$ERRORS"
  exit 1
else
  printf '\033[0;32m✓ All pre-commit checks passed.\033[0m\n\n'
fi
