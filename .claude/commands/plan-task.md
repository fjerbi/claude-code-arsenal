# Plan Task

Goal: produce a minimal, dependency-aware execution plan.

## Trigger

Run WHEN complexity ≥ COMPLEX or when multiple steps are needed.

## Protocol

1. Summarize objective and acceptance criteria.
2. Break task into smallest meaningful steps.
3. Order steps by dependency.
4. Identify parallelizable branches.
5. Define verification checkpoint for each step.
6. Note risks and assumptions.

## Output

```
Objective: [one sentence]
Steps:
  1. [step] → verify: [check]
  2. [step] → verify: [check]
Parallel: [branches if any]
Risks: [list]
```

## Guardrails

- NEVER create architecture-level plans for local fixes.
- NEVER include speculative tasks.
- Prefer short plans over comprehensive ones.
