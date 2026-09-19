# Quality Gate

Goal: determine whether a task is ready to stop.

## Trigger

Run BEFORE declaring any task complete.

## Protocol

- [ ] The user request was understood and solved.
- [ ] Scope stayed bounded — no unrelated changes.
- [ ] The patch matches the request.
- [ ] Verification was run and evidence recorded.
- [ ] No unrelated user work was modified.
- [ ] No remaining direct blocker is unresolved.
- [ ] Significant decisions were documented.
- [ ] System invariants still hold.

## Decision

- ALL checks pass → **STOP. Task complete.**
- Any check fails → address the failure before stopping.
- Verification missing → run verification first.
- Evidence unclear → re-run with explicit output.

## Guardrails

- NEVER stop because a patch looks plausible.
- NEVER override evidence with optimism.
- NEVER treat assumptions as proof.
