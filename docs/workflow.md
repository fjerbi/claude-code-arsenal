# Standard Workflow

## Execution Sequence

1. **Triage** — Classify complexity, define objective, identify scope.
2. **Research** — Gather minimum relevant evidence from the repo.
3. **Plan** — WHEN complexity ≥ COMPLEX: produce a dependency-ordered plan.
4. **Implement** — Apply TDD when possible. Make changes in dependency order.
5. **Verify** — Run verification scaled to risk level (AGENTS.md §12).
6. **Self-Review** — Run quality gate (AGENTS.md §20).
7. **Report** — Structured output: Implemented → Verified → Remaining.

## Complexity Decision Tree

```
Is it a single-symbol, constant, typo, or label change?
  → YES: TRIVIAL. Act immediately.
  → NO: continue.

Does it affect a single file or function?
  → YES: NORMAL. Investigate → implement → verify.
  → NO: continue.

Does it span multiple files or modules?
  → YES: Does it affect architecture, security, or public APIs?
    → YES: CRITICAL. Deep analysis → plan → phased execution → comprehensive verification.
    → NO: COMPLEX. Plan → phase → verify each phase.
```

## Verification Matrix

| Change Type | Minimum Verification | Escalation |
|---|---|---|
| Type/interface | Type check | Integration test |
| API/contract | Integration test | Broader suite |
| Business logic | Unit test | Root cause analysis |
| UI/visual | Visual check | User review |
| Data/schema | Migration test | Rollback test |
| Security | Security audit | Block until resolved |
| Config | Smoke test | Config chain inspection |
| Dependency | Build + tests | Version investigation |

## Parallel Work

Only parallelize when:
- Tasks are genuinely independent.
- No shared file modifications.
- Each task has clear ownership boundaries.
- Results can be independently verified.

## When to Stop

- Task is complete and verified with evidence.
- Acceptance criteria are met.
- Self-review gate passes.
- No blocking issues remain.
