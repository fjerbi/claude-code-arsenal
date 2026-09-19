# Handoff Protocol

Use this whenever work moves between agents, phases, or execution branches.

## Required handoff content
- Objective and current phase
- Scope boundary and files involved
- Current status and what is complete
- Evidence gathered so far
- Open risks or assumptions
- Next action required
- Validation path to confirm completion

## Hand-off format
```text
Objective:
Current phase:
Files involved:
Status:
Evidence:
Open risks:
Next action:
Validation:
```

## Rules
- Do not hand off a vague task.
- Do not merge parallel branches without validation evidence.
- Do not hide unresolved assumptions.
- Preserve dependency ordering.
- Keep each handoff explicit and minimal.

## Completion rule
A handoff is only complete when the receiving agent can continue without guessing.
