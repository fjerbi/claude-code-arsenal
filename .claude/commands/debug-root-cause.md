# Debug Root Cause

Goal: find the actual reason for a failure before patching.

Steps:
1. Reproduce or inspect the failure precisely.
2. Identify the exact behavior that diverges from expectations.
3. Trace the data flow and boundary conditions to the failing layer.
4. State the root cause in one sentence before proposing a fix.
5. Apply the smallest proof-backed repair.
6. Re-validate the changed behavior.

Guardrails:
- Do not patch on guesswork.
- Do not stack speculative changes.
- Do not keep retrying the same failed action without new evidence.
