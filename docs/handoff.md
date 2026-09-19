# Handoff Protocol

Use this whenever work transfers between agents, phases, or execution branches.

## Handoff Template

```
Objective: [original task in one sentence]
Phase: [current phase in execution protocol]
Complexity: [TRIVIAL/NORMAL/COMPLEX/CRITICAL]
Files involved: [list of files touched or relevant]
Status: [what is complete, with evidence]
Evidence:
  - [what was verified, exact output]
  - [what was checked, result]
Assumptions:
  - [what was assumed but not verified]
Risks:
  - [known issues or uncertainties]
Decisions made:
  - [key choices and rationale]
Next action: [concrete next step]
Verification path: [how to confirm completion]
```

## Rules

- A handoff is complete ONLY when the receiving agent can continue without guessing.
- NEVER hand off a vague task.
- NEVER hide unresolved assumptions.
- NEVER merge parallel branches without validation evidence.
- Preserve dependency ordering.
- Keep handoffs concise and factual.

## Evidence Chain

Every handoff must include an evidence chain:

1. What was the starting state?
2. What changes were made?
3. What evidence confirms the changes are correct?
4. What remains unverified?

## Receiving a Handoff

1. Read the handoff document.
2. Inspect the actual repository state (git status, git diff).
3. Verify claims against evidence — do not trust stale information.
4. Identify any gaps or contradictions.
5. Continue based on verified state, not the handoff alone.
