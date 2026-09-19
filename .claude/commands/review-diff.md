# Review Diff

Goal: verify the current patch matches the task with no unintended changes.

## Trigger

Run BEFORE committing or declaring completion.

## Protocol

1. Inspect the diff for scope and intent.
2. Check for: unrelated refactors, debug artifacts, leftover comments, scope expansion.
3. Verify changes match the original request.
4. Confirm user work was preserved.
5. Check that verification was run for affected areas.
6. Report risks or follow-up items.

## Output

```
Scope: [in-scope / expanded]
Unintended changes: [none / list]
User work: [preserved / affected]
Verification: [adequate / needed]
Risks: [list]
```

## Guardrails

- NEVER silently expand scope.
- NEVER overwrite user changes.
- NEVER approve without checking verification status.
