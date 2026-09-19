# Safety Review

Goal: prevent unintended changes, security issues, and sloppy execution.

## Trigger

Run WHEN changes affect security, user data, authentication, or destructive operations.

## Protocol

1. Check for unrelated scope changes.
2. Check for destructive or risky commands.
3. Verify user-owned work was preserved.
4. Check for exposed secrets, credentials, or tokens.
5. Verify authentication/authorization not weakened.
6. Confirm change was tested.

## Decision Rules

- WHEN security concern found → BLOCK immediately.
- WHEN user work at risk → BLOCK until preserved.
- WHEN scope expanded without justification → REVISE.
- WHEN all checks pass → ACCEPT.

## Guardrails

- NEVER hide risky changes.
- NEVER approve without evidence.
- NEVER weaken security controls for convenience.
