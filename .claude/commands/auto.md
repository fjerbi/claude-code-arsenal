---
description: Autopilot — triage a task and run it end-to-end, delegating noisy work (broad search, long test runs, review) to cheap subagents so the main context stays small.
argument-hint: <task description>
---

# Auto

Goal: complete the task end-to-end with the fewest main-context tokens.

Task: $ARGUMENTS

## Trigger

Run for any task you want executed hands-off. This command is the orchestrator — it runs in the main thread, which is the only place subagents can be dispatched from.

## Protocol

1. **Triage inline** (no tool calls if the task is already clear): complexity TRIVIAL / NORMAL / COMPLEX / CRITICAL, risk LOCAL / MODULE / SYSTEM.
2. **Route:**

| Class | Pipeline |
|---|---|
| TRIVIAL | Edit directly → stop. |
| NORMAL | Targeted Grep/Glob → edit → run the one relevant test → stop. |
| COMPLEX | `researcher` → `planner` → one `fixer` per independent workstream (parallel) → `validator` → stop. |
| CRITICAL | COMPLEX pipeline + `reviewer`. Show the plan and wait for user approval before any edit. |

3. **Delegate by cost, not habit.** Dispatch a subagent only when it keeps bulk output out of the main context:
   - Search across many files or unknown locations → `researcher` (Sonnet). Ask for file:line facts only.
   - Test/build runs with long output → `validator` (Sonnet). Ask for PASS/FAIL + the failing excerpt only.
   - Anything answerable with 1–3 targeted Grep/Read calls → do it inline.
4. **Brief subagents completely** — they start cold. Give: objective, files/symbols already known, owned files (parallel fixers must not overlap), expected output format, and "do not re-derive what is given".
5. **Launch independent subagents in one message** so they run in parallel.
6. **Verify once**, scaled to risk: LOCAL → unit/smoke test; MODULE → integration + type check; SYSTEM → full suite + type check + `reviewer`. Hooks already check syntax, JSON, and merge markers on every edit and at stop — do not duplicate those checks.
7. **Report** `Implemented / Verified / Remaining` and STOP.

## Guardrails

- NEVER dispatch subagents for TRIVIAL/NORMAL work unless step 3 applies.
- NEVER dispatch `orchestrator` as a subagent — subagents cannot spawn subagents.
- NEVER let two parallel fixers own the same file.
- Failure budget: attempt 1 targeted → 2 new hypothesis → 3 new strategy → then STOP and report evidence.
- CRITICAL: no edits before the user approves the plan.
