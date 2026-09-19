# Verification Contracts

Reference guide for the verification discipline defined in AGENTS.md §12.

## Change Type → Verification Mapping

| Change Type | Required Verification | Escalation Trigger |
|---|---|---|
| Type or interface change | Type check (tsc, mypy, cargo check) | Fails → integration test |
| API or contract change | Integration test | Fails → broader test suite |
| Business logic change | Unit test for changed behavior | Fails → root cause analysis |
| UI or visual change | Visual verification / screenshot | Unclear → user review |
| Data or schema change | Migration test + rollback check | Fails → rollback |
| Security-sensitive change | Security audit + reviewer | Any concern → block |
| Configuration change | Smoke test | Fails → inspect config chain |
| Dependency change | Build + existing test suite | Fails → version investigation |
| Refactor (no behavior change) | Existing tests pass unchanged | Any failure → revert |

## Risk Level → Verification Depth

| Risk Level | Verification Depth |
|---|---|
| LOCAL (single function) | Targeted unit test or smoke check |
| MODULE (module API) | Integration test + type check |
| SYSTEM (architecture/security) | Full test suite + type check + reviewer |

## Composable Verification Layers

Apply layers in order. Stop when confidence is sufficient:

1. **Static analysis:** Type check, lint. Fast, catches obvious errors.
2. **Unit tests:** Targeted tests for changed behavior. Medium speed, high confidence.
3. **Integration tests:** Cross-module behavior. Slower, catches contract violations.
4. **End-to-end tests:** Full system behavior. Slowest, highest confidence.

For most changes, layers 1-2 are sufficient. Escalate only when evidence requires it.

## Evidence Format

Verification evidence must include:
- The exact command that was run.
- The actual output (or relevant excerpt).
- Pass/fail determination.
- IF failed: what the failure indicates.

NEVER summarize verification. Show the actual output.

## When Verification Cannot Be Run

IF the required verification is unavailable:
1. State what verification was needed.
2. State why it cannot be run.
3. Use the best available alternative.
4. Explicitly note the confidence gap.
