# Triage Task

Goal: classify and scope a task before execution.

## Trigger

Run BEFORE any implementation work begins.

## Protocol

1. Restate the objective in one sentence.
2. Classify complexity: TRIVIAL / NORMAL / COMPLEX / CRITICAL (AGENTS.md §1).
3. Identify relevant files, modules, or systems.
4. Classify change type: bug fix, feature, refactor, investigation.
5. Assess risk and blast radius (AGENTS.md §7).
6. List constraints, unknowns, and assumptions.
7. Determine the smallest safe next action.

## Output

```
Objective: [one sentence]
Complexity: [level]
Type: [bug fix / feature / refactor / investigation]
Risk: [LOCAL / MODULE / SYSTEM]
Scope: [files or modules]
Constraints: [list]
Unknowns: [list]
Next action: [concrete step]
```

## Guardrails

- NEVER broaden scope without evidence.
- NEVER start editing before the task is understood.
- IF unclear → state uncertainty, ask only if necessary.
