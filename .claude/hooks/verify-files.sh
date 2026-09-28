#!/usr/bin/env bash
# Claude Code Arsenal — Automatic File Verification (Claude Code hook)
#
# Modes:
#   edit — PostToolUse on Write|Edit|MultiEdit: checks the file just written.
#   stop — Stop: checks every changed/untracked file before Claude finishes
#          (catches files modified through Bash, e.g. sed or generators).
#
# Checks: merge-conflict markers, and syntax for .sh/.bash, .json, .py, .js/.mjs/.cjs.
#
# Contract (Claude Code hooks):
#   exit 0 — all good (no output, zero tokens)
#   exit 2 — problems found; stderr is fed back to Claude so it fixes them
#            without spending tool calls on manual checks.
#
# Wired in .claude/settings.json → hooks.PostToolUse and hooks.Stop.

set -uo pipefail

MODE="${1:-edit}"
INPUT="$(cat)"

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

# Pure-bash JSON string extraction (no forks — keeps the hook fast on Windows).
json_field() {
  local re="\"$1\""'[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)"' v
  [[ "$INPUT" =~ $re ]] || return 0
  v="${BASH_REMATCH[1]}"
  v="${v//\\\"/\"}"
  printf '%s' "${v//\\\\/\\}"
}

# Probed lazily: on Windows `python3` may be a slow Microsoft Store stub.
PY_OK=""
py_ok() {
  [[ -z "$PY_OK" ]] && { python3 -c '' > /dev/null 2>&1 && PY_OK=yes || PY_OK=no; }
  [[ "$PY_OK" == "yes" ]]
}

# Prints the parser error and returns non-zero on invalid JSON.
# Returns 0 when no JSON parser is available.
check_json() {
  if command -v jq > /dev/null 2>&1; then
    jq empty "$1" 2>&1 > /dev/null
  elif command -v node > /dev/null 2>&1; then
    node -e 'try{JSON.parse(require("fs").readFileSync(process.argv[1],"utf8").trim())}catch(e){console.log(e.message);process.exit(1)}' "$1"
  elif py_ok; then
    python3 -c 'import json,sys; json.load(open(sys.argv[1],encoding="utf-8-sig"))' "$1" 2>&1 | tail -n 1
    return "${PIPESTATUS[0]}"
  fi
}

ERRORS=""

check_file() {
  local file="$1" out
  [[ -f "$file" ]] || return 0

  out="$(grep -nE '^(<<<<<<<|>>>>>>>) ' "$file" 2>/dev/null | head -n 3)"
  [[ -n "$out" ]] && ERRORS+="$file: merge-conflict markers"$'\n'"$out"$'\n'

  case "$file" in
    *.sh|*.bash)
      out="$(bash -n "$file" 2>&1)" || ERRORS+="$file: shell syntax error"$'\n'"$out"$'\n'
      ;;
    *.jsonc|*tsconfig*.json|*jsconfig*.json|*.vscode*.json|*devcontainer*.json)
      ;; # JSON-with-comments dialects — not strict JSON
    *.json)
      out="$(check_json "$file")" || ERRORS+="$file: invalid JSON"$'\n'"$out"$'\n'
      ;;
    *.py)
      if py_ok; then
        out="$(python3 -c 'import ast,sys; ast.parse(open(sys.argv[1],encoding="utf-8").read(),sys.argv[1])' "$file" 2>&1 | tail -n 3)" \
          || ERRORS+="$file: Python syntax error"$'\n'"$out"$'\n'
      fi
      ;;
    *.js|*.mjs|*.cjs)
      if command -v node > /dev/null 2>&1; then
        out="$(node --check "$file" 2>&1 | head -n 6)" || ERRORS+="$file: JavaScript syntax error"$'\n'"$out"$'\n'
      fi
      ;;
  esac
}

case "$MODE" in
  edit)
    FILE="$(json_field file_path)"
    [[ -z "$FILE" ]] && exit 0
    check_file "$FILE"
    HEADER="Arsenal verify: the file you just wrote has problems — fix them now:"
    ;;
  stop)
    # Second stop attempt after a block → let Claude finish (prevents loops).
    printf '%s' "$INPUT" | grep -qE '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
    git rev-parse --is-inside-work-tree > /dev/null 2>&1 || exit 0
    while IFS= read -r f; do
      [[ -n "$f" ]] && check_file "$f"
    done < <({ git diff --name-only HEAD -- 2>/dev/null || git diff --name-only; \
               git ls-files --others --exclude-standard; } | sort -u | head -n 200)
    HEADER="Arsenal verify: changed files have problems. Fix the ones you touched; if a file is pre-existing user work outside task scope, report it instead of fixing:"
    ;;
  *)
    echo "Usage: verify-files.sh [edit|stop]  (reads Claude Code hook JSON on stdin)" >&2
    exit 1
    ;;
esac

if [[ -n "$ERRORS" ]]; then
  { echo "$HEADER"; printf '%s' "$ERRORS" | head -n 40; } >&2
  exit 2
fi
exit 0
