---
description: Classify a task (complexity, type, risk, scope) and decide the smallest safe next action before any edit.
argument-hint: <task description>
---

# Triage Task

Goal: classify and scope a task before execution.

Task: $ARGUMENTS

## Trigger

Run BEFORE implementation work when scope or risk is unclear. For hands-off execution use `/auto`, which triages itself.

## Protocol

1. Restate the objective in one sentence.
2. Complexity: TRIVIAL (one symbol/typo) / NORMAL (scoped fix, one module) / COMPLEX (multi-file, cross-module) / CRITICAL (security, data, public API). Unsure → NORMAL.
3. Identify relevant files, modules, or systems (targeted search only).
4. Change type: bug fix, feature, refactor, investigation.
5. Risk: LOCAL / MODULE / SYSTEM.
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
