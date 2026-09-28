#!/usr/bin/env bash
# Claude Code Arsenal — Bash Guard (Claude Code PreToolUse hook)
# Deterministically blocks destructive commands before they run.
#
# Contract (Claude Code hooks):
#   stdin  — hook JSON ({"tool_input":{"command":"..."}})
#   exit 0 — allow (no output, zero tokens)
#   exit 2 — block; stderr is fed back to Claude
#
# Wired in .claude/settings.json → hooks.PreToolUse (matcher: Bash).
# Disable for a session: set ARSENAL_GUARD=off in .claude/settings.local.json "env".

set -u

[[ "${ARSENAL_GUARD:-on}" == "off" ]] && exit 0

INPUT="$(cat)"

# Pure-bash JSON string extraction (no forks — this hook runs before every Bash call).
JSON_STR='"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)"'
[[ "$INPUT" =~ $JSON_STR ]] || exit 0
CMD="${BASH_REMATCH[1]}"
CMD="${CMD//\\\"/\"}"
CMD="${CMD//\\\\/\\}"
[[ -z "$CMD" ]] && exit 0

# Command-start boundary: line start, or after ; & | ( or backtick.
B='(^|[;&|(`])[[:space:]]*'

RULES=(
  "${B}sudo[[:space:]]|privilege escalation (sudo)"
  "${B}rm[[:space:]]+(-[[:alnum:]-]+[[:space:]]+)*(/|/\*|~|~/|\\\$HOME|\\\$\{HOME\})([[:space:]]|$)|recursive delete of / or home"
  "${B}git[[:space:]]+push[[:space:]].*(--force|[[:space:]]-f([[:space:]]|$)|[[:space:]]\+[^[:space:]]+)|force push (rewrites remote history)"
  "${B}git[[:space:]]+(commit|push)[[:space:]].*--no-verify|--no-verify bypasses the pre-commit secret scan"
  "${B}git[[:space:]]+reset[[:space:]]+(.*[[:space:]])?--hard|git reset --hard discards user work"
  "${B}git[[:space:]]+clean[[:space:]]+(.*[[:space:]])?-[[:alpha:]]*f|git clean -f deletes untracked user files"
  "${B}git[[:space:]]+checkout[[:space:]]+(--[[:space:]]+)?\.([[:space:]]|$)|git checkout . discards all working-tree changes"
  "${B}git[[:space:]]+restore[[:space:]]+(-W[[:space:]]+|--worktree[[:space:]]+)?\.([[:space:]]|$)|git restore . discards all working-tree changes"
  "${B}(curl|wget)[[:space:]].*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z|da)?sh([[:space:]]|$)|piping a download into a shell"
  "${B}mkfs|filesystem format (mkfs)"
  "${B}dd[[:space:]].*of=/dev/|raw write to a block device (dd)"
  "${B}chmod[[:space:]]+(-R[[:space:]]+)?777[[:space:]]+/([[:space:]]|$)|chmod 777 on /"
  "${B}find[[:space:]]+/[[:space:]].*-delete|find / -delete"
  ":\(\)[[:space:]]*\{[[:space:]]*:[[:space:]]*\|[[:space:]]*:|fork bomb"
)

# Check each line separately (JSON "\n" = new line = new command start).
CMD="${CMD//\\n/$'\n'}"
while IFS= read -r line; do
  for rule in "${RULES[@]}"; do
    pattern="${rule%|*}"
    if [[ "$line" =~ $pattern ]]; then
      printf 'Arsenal guard blocked this command: %s.\n' "${rule##*|}" >&2
      printf 'Do not retry or work around it. If the user explicitly wants this, ask them to run it themselves.\n' >&2
      exit 2
    fi
  done
done <<< "$CMD"

exit 0
