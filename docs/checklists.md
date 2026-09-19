# Checklists

## Before Starting

- [ ] Read the full request.
- [ ] Classify complexity (AGENTS.md §1).
- [ ] Identify scope and constraints.
- [ ] Check git status for existing work.
- [ ] Classify risk / blast radius (AGENTS.md §7).

## Before Editing

- [ ] Root cause or requirement established with evidence.
- [ ] Understand what must change and what must stay the same.
- [ ] User work inspected and protected.
- [ ] Verification strategy identified.

## Before Committing

- [ ] Verification ran with passing output.
- [ ] Git diff checked for unintended changes.
- [ ] No secrets, credentials, or debug artifacts included.
- [ ] Changes match the original request — nothing extra.
- [ ] Existing tests still pass.

## Before Declaring Done

- [ ] Acceptance criteria verified with evidence.
- [ ] Self-review gate passed (AGENTS.md §20).
- [ ] Quality gate passed (commands/quality-gate.md).
- [ ] Significant decisions documented.
- [ ] Remaining risks reported (if any).

## Before Parallel Dispatch

- [ ] Workstreams confirmed independent.
- [ ] File ownership boundaries defined — no overlaps.
- [ ] Each branch has its own verification path.
- [ ] Handoff format defined for consolidation.
