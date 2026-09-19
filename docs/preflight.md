# Preflight Checklist

Run before starting or delegating work.

## 1. Objective Check

- [ ] Task stated in one sentence.
- [ ] Expected outcome is clear.
- [ ] Acceptance criteria are explicit enough to validate.

## 2. Complexity Classification

- [ ] Classified as TRIVIAL / NORMAL / COMPLEX / CRITICAL (AGENTS.md §1).
- [ ] Reasoning depth matches complexity (AGENTS.md §2).

## 3. Scope Check

- [ ] Work bounded to relevant files or subsystem.
- [ ] Not broadening into unrelated cleanup.
- [ ] Will not touch unrelated user work.

## 4. Risk Classification

- [ ] Blast radius classified: LOCAL / MODULE / SYSTEM (AGENTS.md §7).
- [ ] Verification depth matches risk level (AGENTS.md §12).

## 5. Impact Analysis (for COMPLEX+ tasks)

- [ ] Identified all files that will change.
- [ ] Mapped dependencies (what calls/imports the changed code).
- [ ] Assessed downstream consumers.
- [ ] Identified potential breaking changes.

## 6. Evidence Check

- [ ] Relevant repo evidence inspected.
- [ ] Root cause or requirement identified before patching.
- [ ] Unknowns stated, not assumed.

## 7. Safety Check

- [ ] Existing user changes protected (git status checked).
- [ ] No destructive commands needed.
- [ ] Dependencies and side effects understood.

## 8. Agent Routing Check

- [ ] Primary role matches the job.
- [ ] Work not over-distributed.
- [ ] Parallel work is safe and independent.

## 9. Validation Check

- [ ] Smallest relevant verification identified.
- [ ] Expected result is observable.
- [ ] Verification command known.

## 10. Stop Condition Check

- [ ] Task has a defined end state.
- [ ] Completion can be determined from evidence.

IF any item is missing → pause and resolve before continuing.

## Rollback Plan (for COMPLEX+ tasks)

- [ ] Identified rollback points.
- [ ] Know how to revert if verification fails.
- [ ] User work preservation confirmed.
