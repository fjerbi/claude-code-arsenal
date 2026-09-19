# Validate Change

Goal: verify a change with the smallest meaningful proof.

## Trigger

Run AFTER any code change to confirm correctness.

## Protocol

1. Identify change type and map to verification contract (AGENTS.md §12).
2. Determine risk level: LOCAL / MODULE / SYSTEM (AGENTS.md §7).
3. Run the smallest verification that matches the risk:
   - LOCAL → unit test or smoke check.
   - MODULE → integration test + type check.
   - SYSTEM → comprehensive suite + type check.
4. Capture exact command and output.
5. IF fails → report exact failure, do not retry blindly.

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
