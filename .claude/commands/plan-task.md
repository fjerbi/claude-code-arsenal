---
description: Produce a short, dependency-ordered execution plan with verification checkpoints and parallel branches for COMPLEX/CRITICAL work.
argument-hint: <objective>
---

# Plan Task

Goal: produce a minimal, dependency-aware execution plan.

Objective: $ARGUMENTS

## Trigger

Run WHEN complexity ≥ COMPLEX or when multiple steps are needed.

## Protocol

1. Summarize objective and acceptance criteria.
2. Break the task into the smallest meaningful steps.
3. Order steps by dependency.
4. Identify parallelizable branches — only when they own disjoint files.
5. Define a verification checkpoint for each step.
6. Note risks and assumptions.

## Output

```
Objective: [one sentence]
Steps:
  1. [step] → verify: [check]
  2. [step] → verify: [check]
Parallel: [branches + owned files, if any]
Risks: [list]
```

## Guardrails

- NEVER create architecture-level plans for local fixes.
- NEVER include speculative tasks.
- Prefer short plans over comprehensive ones.
