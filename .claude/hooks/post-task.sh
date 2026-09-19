#!/usr/bin/env bash
# Claude Code Arsenal — Post-Task Hook
# Runs cleanup after a Claude Code task completes.
#
# Actions:
#   1. Remove progress.md if task is complete
#   2. Check for stale debug artifacts
#   3. Report git status summary
#   4. Suggest next steps
#
# Usage: bash .claude/hooks/post-task.sh

set -eu

pass() {
  printf '\033[0;32m✓\033[0m %s\n' "$1"
}

warn() {
  printf '\033[1;33m⚠\033[0m %s\n' "$1"
}

info() {
  printf '\033[0;34m→\033[0m %s\n' "$1"
}

printf '\n\033[0;34m── Post-Task Cleanup ──\033[0m\n\n'

# --- 1. Clean up progress.md ---
if [[ -f "progress.md" ]]; then
  warn "progress.md exists — removing (task state should live in commits)"
  rm -f "progress.md"
  pass "Removed progress.md"
else
  pass "No stale progress.md"
fi

# --- 2. Check for debug artifacts in working tree ---
DEBUG_FILES=()
while IFS= read -r -d '' file; do
  # Check for common debug statements in recently modified files
  if grep -lE '(console\.log|debugger;|binding\.pry|pdb\.set_trace|breakpoint\(\)|TODO REMOVE|FIXME REMOVE)' "$file" 2>/dev/null | head -1 > /dev/null 2>&1; then
    DEBUG_FILES+=("$file")
  fi
done < <(git diff --name-only -z 2>/dev/null || true)

if [[ ${#DEBUG_FILES[@]} -gt 0 ]]; then
  warn "Debug artifacts found in modified files:"
  for f in "${DEBUG_FILES[@]}"; do
    printf '    %s\n' "$f"
  done
else
  pass "No debug artifacts in modified files"
fi

# --- 3. Git status summary ---
echo ""
info "Git status summary:"

STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l)
MODIFIED=$(git diff --name-only 2>/dev/null | wc -l)
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)

printf '    Staged:    %d files\n' "$STAGED"
printf '    Modified:  %d files\n' "$MODIFIED"
printf '    Untracked: %d files\n' "$UNTRACKED"

# --- 4. Suggest next steps ---
echo ""
info "Next steps:"
if [[ $MODIFIED -gt 0 || $STAGED -gt 0 ]]; then
  echo "  1. Review changes: git diff"
  echo "  2. Stage changes:  git add -p"
  echo "  3. Commit:         git commit -m 'description'"
  echo "  4. Push:           git push"
else
  echo "  Working tree is clean. No action needed."
fi
echo ""
