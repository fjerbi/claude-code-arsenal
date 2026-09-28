---
description: Fix a bug with the OHTF cycle (observe → hypothesize → test → fix) and TDD, verified with real test output.
argument-hint: <bug description or error message>
---

# Fix Bug

Goal: resolve a bug with evidence-based, minimal changes.

Bug: $ARGUMENTS

## Trigger

Run WHEN the task is a bug fix.

## Protocol

1. Reproduce or confirm the failure. Capture the exact error.
2. OHTF cycle:
   - OBSERVE: exact error output.
   - HYPOTHESIZE: "X fails because Y; I will verify by checking Z."
   - TEST: minimal probe that confirms or denies it.
   - FIX: smallest verified edit.
3. TDD when the project has a test framework: failing test reproducing the bug → fix → test passes → no regressions.
4. Verify scaled to risk: LOCAL → unit/smoke test; MODULE → integration + type check; SYSTEM → full suite + type check.
5. Report the result with actual output.

## Delegation (only when it saves context)

- Location unknown and search is broad → `researcher` subagent returns file:line facts.
- Test output is long → `validator` subagent returns PASS/FAIL + failing excerpt.
- Otherwise act inline.

## Evidence Required

- Root cause identified with evidence.
- Fix verified with actual test output.
- No regressions introduced.

## Guardrails

- NEVER patch without a proven root cause.
- NEVER refactor unrelated code or broaden scope.
- NEVER claim success without verification output.
- Failure budget: attempt 1 targeted → 2 new hypothesis → 3 new strategy → then STOP and report.
