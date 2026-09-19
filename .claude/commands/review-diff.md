# Review Diff

Goal: verify that the current patch matches the task and does not include unrelated changes.

Steps:
1. Inspect the diff for scope and intent.
2. Check for accidental refactors, debug code, or unrelated edits.
3. Ensure changes match the request and preserve behavior.
4. Confirm verification was run for the affected area.
5. Report any remaining risks or follow-up work.

Guardrails:
- Do not silently expand scope.
- Do not overwrite user changes.
- Stop when the diff is clean and justified.
