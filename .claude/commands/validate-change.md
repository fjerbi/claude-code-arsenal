# Validate Change

Goal: confirm the changed behavior with the smallest meaningful proof.

Steps:
1. Identify the relevant validation path.
2. Run the smallest command that checks the changed behavior.
3. Interpret the result carefully.
4. If validation fails, fix the root cause and re-run.
5. Report the exact evidence.

Guardrails:
- Prefer targeted tests or checks over broad suites.
- Do not claim success without actual output.
- Keep validation scoped to the affected behavior.
