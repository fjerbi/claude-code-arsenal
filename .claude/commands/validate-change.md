---
description: Verify the current change with the smallest meaningful proof (targeted test, type check, smoke check) and report actual output.
argument-hint: [changed files or area — defaults to the current diff]
---

# Validate Change

Goal: verify a change with the smallest meaningful proof.

Scope: $ARGUMENTS

## Trigger

Run AFTER a code change to confirm correctness. Syntax/JSON/merge-marker checks already run automatically via hooks — this command covers behavior.

## Protocol

1. Map change type to verification:

| Change | Verification |
|---|---|
| Type/interface | Type check (tsc, mypy, cargo check) |
| API/contract | Integration test |
| Business logic | Unit test for the changed behavior |
| Config | Smoke test |
| Dependency | Build + existing suite |
| Security-sensitive | `/safety-review` + targeted audit |

2. Scale by risk: LOCAL → unit/smoke; MODULE → integration + type check; SYSTEM → full suite + type check.
3. Long output expected → delegate to the `validator` subagent, or wrap with `bash scripts/log-filter.sh "<cmd>"`.
4. Capture exact command and output.
5. IF it fails → report the exact failure; do not retry blindly.

## Output

```
Result: [PASS/FAIL]
Command: [exact command]
Output: [actual output]
Risk level: [LOCAL/MODULE/SYSTEM]
Gaps: [what could not be verified]
```

## Guardrails

- NEVER claim success without actual output.
- NEVER run broad suites when focused checks suffice.
- NEVER summarize failures — show them.
