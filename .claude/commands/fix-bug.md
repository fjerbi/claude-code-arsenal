# Fix Bug

Goal: resolve a bug with the smallest possible, evidence-based change.

Steps:
1. Identify the precise failing behavior and scope.
2. Find the relevant code and root cause.
3. Patch only the affected behavior.
4. Add or update a targeted regression test if the project supports it.
5. Run the smallest relevant validation.
6. Stop when the bug is fixed and verification passes.

Guardrails:
- Do not refactor unrelated code.
- Do not broaden scope.
- Do not claim success without a verification result.
- Preserve user work and existing conventions.
