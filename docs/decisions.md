# Decision Documentation

Reference guide for the decision documentation protocol defined in AGENTS.md §14.

## When to Document

Document a decision when:
- Choosing between multiple valid architectural approaches.
- Making a tradeoff that affects future development.
- Deviating from an established pattern.
- Accepting a known limitation or risk.

Do not document trivial implementation choices.

## Lightweight Decision Record

For significant decisions during a task:

```
Decision: [what was decided]
Context: [why this decision was needed]
Options considered:
  1. [option A] — [tradeoff]
  2. [option B] — [tradeoff]
  3. [option N] — [tradeoff]
Chosen: [which option and why]
Accepted tradeoffs: [what we give up]
```

Keep it to one paragraph per field. Conciseness matters.

## Pre-Mortem

For CRITICAL complexity tasks, before implementing:

1. Assume the implementation has shipped and failed.
2. List the most likely causes of failure.
3. For each cause: what would prevent it?
4. Address the top risks in the implementation plan.

## Tradeoff Analysis

When comparing approaches:

| Criterion | Option A | Option B |
|---|---|---|
| Correctness | | |
| Complexity | | |
| Risk | | |
| Reversibility | | |
| Maintenance cost | | |

Choose based on the priority order: correctness → security → simplicity → maintainability.
