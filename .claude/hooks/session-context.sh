#!/usr/bin/env bash
# Claude Code Arsenal — Session Context (Claude Code SessionStart hook)
# Auto-resumes long-running work: if progress.md exists (CLAUDE.md §27), its
# contents are injected into context so no tool call is needed to pick up state.
# Prints nothing otherwise (zero tokens). Git status is already provided by
# Claude Code, so it is deliberately not repeated here.
#
# Wired in .claude/settings.json → hooks.SessionStart.

set -u

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

if [[ -f progress.md ]]; then
  echo "[arsenal] progress.md found — resume from this state (verify against the repo before acting):"
  head -n 60 progress.md
fi
exit 0
