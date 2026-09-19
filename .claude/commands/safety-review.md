# Safety Review

Goal: prevent unintended changes and sloppy execution.

Steps:
1. Inspect the patch for unrelated scope changes.
2. Check for destructive or risky commands.
3. Confirm that user-owned work was preserved.
4. Review whether the change matches the request.
5. Verify that the changed behavior was tested.

Guardrails:
- Do not hide risky changes.
- Do not approve a patch without evidence.
- Do not treat assumptions as facts.
