---
description: Find the proven root cause of a failure before any patch — hypothesis-driven, no speculative edits.
argument-hint: <symptom or error message>
---

# Debug Root Cause

Goal: find the actual cause of a failure before patching.

Symptom: $ARGUMENTS

## Trigger

Run WHEN the root cause is unknown or the bug is not reproducible.

## Protocol

1. **OBSERVE:** Reproduce the failure. Capture exact error output.
2. **HYPOTHESIZE:** "Component X fails because Y. I will verify by checking Z."
3. **TEST:** Run the minimal probe. Record the result.
4. IF confirmed → state root cause and proceed to fix.
5. IF denied → return to step 2 with new evidence.
6. Broad code search needed → delegate to `researcher` subagent; keep only its facts in context.

## Output

```
Root cause: [proven cause with evidence]
Evidence: [what was checked and found]
Hypotheses tested:
  1. [hypothesis] → [result]
Recommended fix: [smallest change]
```

## Guardrails

- NEVER patch on guesswork.
- NEVER stack speculative changes.
- NEVER retry without new evidence.
- After 3 failed hypotheses → STOP and report what was tried and what remains unknown.
