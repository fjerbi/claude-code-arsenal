#!/usr/bin/env bash
# Claude Code Arsenal — Session Context (Claude Code SessionStart hook)
# 1. Auto-resumes long-running work: if progress.md exists (CLAUDE.md §27), its
#    contents are injected into context so no tool call is needed to pick up state.
# 2. Detects the framework stack: one line with exact versions, so version-aware
#    skills (.claude/skills/) load the right reference without a tool call.
# Prints nothing when neither applies (zero tokens). Git status is already
# provided by Claude Code, so it is deliberately not repeated here.
#
# Wired in .claude/settings.json → hooks.SessionStart.

set -u

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

if [[ -f progress.md ]]; then
  echo "[arsenal] progress.md found — resume from this state (verify against the repo before acting):"
  head -n 60 progress.md
fi

# Installed version from node_modules; else the range declared in package.json.
pkg_version() {
  local name="$1" v=""
  if [[ -f "node_modules/$name/package.json" ]]; then
    v="$(sed -n 's/^[[:space:]]*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "node_modules/$name/package.json" | head -n 1)"
  fi
  if [[ -z "$v" ]]; then
    v="$(grep -o "\"$name\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" package.json 2>/dev/null | head -n 1 | sed 's/.*:[[:space:]]*"\([^"]*\)"/\1/')"
    [[ -n "$v" ]] && v="$v [declared only]"
  fi
  [[ -n "$v" ]] && echo "$v"
}

if [[ -f package.json ]]; then
  stack=""
  for pkg in next react; do  # add a package here when its skill lands
    v="$(pkg_version "$pkg")"
    [[ -z "$v" ]] && continue
    entry="$pkg@$v"
    if [[ "$pkg" == "next" ]]; then
      router=""
      [[ -d app || -d src/app ]] && router="app"
      [[ -d pages || -d src/pages ]] && router="${router:+$router+}pages"
      [[ -n "$router" ]] && entry="$entry ($router router)"
    fi
    stack="${stack:+$stack, }$entry"
  done
  [[ -n "$stack" ]] && echo "[arsenal] stack: $stack — write code for these versions; framework skills load the matching reference."
fi
exit 0
