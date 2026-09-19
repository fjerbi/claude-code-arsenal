# Fix Bug

Goal: resolve a bug with evidence-based, minimal changes.

## Trigger

Run WHEN the task is a bug fix.

## Protocol

1. Reproduce or confirm the failure.
2. Run OHTF debugging cycle (AGENTS.md §4):
   - OBSERVE: capture exact error.
   - HYPOTHESIZE: state falsifiable cause.
   - TEST: minimal probe to confirm/deny.
   - FIX: smallest verified edit.
3. Apply TDD when project supports it (AGENTS.md §6):
   - Write failing test reproducing the bug.
   - Fix the code → test passes.
   - Verify no regressions.
4. Run verification scaled to risk level (AGENTS.md §12).
5. Report result with actual output.

## Evidence Required

- Root cause identified with evidence.
- Fix applied and verified with actual test output.
- No regressions introduced.

## Guardrails

- NEVER patch without proven root cause.
- NEVER refactor unrelated code.
- NEVER broaden scope.
- NEVER claim success without verification output.
- Follow failure budget (AGENTS.md §5).
