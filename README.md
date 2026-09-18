# Claude Code Arsenal

> A disciplined operating system for Claude Code — built to maximize engineering efficiency, minimize wasted tokens, prevent hallucinations and endless loops, and keep AI-assisted development focused on the actual task.

## What Is This?

Claude Code Arsenal is a collection of instructions, workflows, conventions, and tools designed to make Claude Code work like a disciplined senior software engineer.

The goal is simple:

**Get the right result with the least unnecessary work.**

Instead of encouraging Claude to:

- Explore endlessly
- Read irrelevant files
- Overthink simple tasks
- Spawn unnecessary agents
- Rewrite working code
- Introduce unnecessary abstractions
- Repeat failed actions
- Consume context on irrelevant details

This system encourages:

**Search → Identify → Inspect → Reason → Change → Verify → Stop**

---

## Core Principles

### 1. Task First

Claude should understand the actual objective before acting.

If the task is clear, it should start immediately.

No unnecessary clarification.

### 2. Minimum Necessary Work

Every action should have a purpose.

Claude should not perform work simply because it might be useful.

### 3. Evidence Over Assumptions

Inspect the repository instead of guessing.

Unknown information should be verified whenever possible.

### 4. Minimal Changes

Solve the problem with the smallest reliable change.

Avoid unrelated refactoring and unnecessary architecture changes.

### 5. Proportional Reasoning

Simple tasks should remain simple.

Complex tasks deserve deeper investigation.

Reasoning effort should match task complexity.

### 6. Targeted Verification

Run the smallest test or check that provides meaningful confidence.

Do not automatically run the entire project test suite.

### 7. No Infinite Loops

When an approach repeatedly fails without new evidence:

**Stop → Reassess → Update the hypothesis.**

Never blindly repeat the same action.

### 8. No Hallucination

Claude must never invent:

- Files
- APIs
- Functions
- Dependencies
- Test results
- Command output
- Repository behavior

When something is unknown, it should say so.

### 9. Protect User Work

Existing uncommitted changes must be treated as user-owned unless clearly established otherwise.

Never casually overwrite or delete existing work.

### 10. Stop When Done

Once the requested behavior works and relevant verification passes:

**STOP.**

Do not manufacture additional work.

---

## Operating Model

The system follows a simple execution model:

1. Receive the user request
2. Understand the task
3. Define the scope
4. Search for relevant code
5. Inspect the evidence
6. Identify the solution
7. Make the smallest necessary change
8. Run targeted verification
9. Fix only if verification reveals a problem
10. Stop when the task is complete

The objective is to avoid unnecessary exploration, repeated reasoning, speculative changes, and excessive tool usage.

---

## Repository Structure

The repository is designed to evolve over time.

Recommended structure:

- `CLAUDE.md` — Core Claude Code operating instructions
- `commands/` — Reusable commands and workflows
- `agents/` — Specialized agents when genuinely useful
- `workflows/` — Repeatable engineering workflows
- `templates/` — Reusable task and project templates
- `scripts/` — Supporting automation
- `README.md` — Documentation and project overview

The core operating system lives in `CLAUDE.md`.

---

## Installation

### Project-Level Installation

Copy `CLAUDE.md` into the root of your project.

Claude Code can then use the instructions while working inside that project.

### Global Installation

If you want the core rules available across multiple projects, place the appropriate `CLAUDE.md` in your Claude Code user-level configuration.

Keep universal engineering rules global and project-specific rules inside individual repositories.

---

## How To Use It

The system is designed to work with short, precise task descriptions.

A good task should communicate:

- What needs to be done
- Expected behavior
- Relevant scope
- Important constraints
- Verification requirements

Example:

> Fix the authentication bug in `src/auth/session.ts`.
>
> Expected behavior:
> - Sessions expire after 7 days.
> - Refreshing a session must not extend expiration.
>
> Constraints:
> - Make the smallest reliable change.
> - Do not refactor unrelated code.
> - Do not add dependencies.
>
> Verification:
> - Run the relevant session tests.
>
> Stop when the behavior works and verification passes.

The permanent instructions handle the engineering discipline.

The task prompt only needs to describe the actual work.

---

## Recommended Task Format

For repeatable work, use this structure:

### TASK

Describe exactly what needs to be done.

### SCOPE

Specify relevant files or components if known.

### EXPECTED RESULT

Describe the exact desired behavior.

### CONSTRAINTS

- Make the smallest necessary change
- Do not refactor unrelated code
- Do not add unnecessary dependencies
- Preserve existing behavior
- Protect existing user changes

### VERIFICATION

Specify the relevant test or check.

### STOP CONDITION

Stop when the expected behavior works and verification passes.

For very small tasks, a much shorter instruction is usually sufficient:

> Fix the specific problem. Make the smallest necessary change. Do not refactor unrelated code. Run the relevant check. Stop when verified.

---

## Token Efficiency

Token efficiency is not about forcing Claude to think less.

It is about preventing unnecessary work.

This project prioritizes:

- Narrow investigation
- Targeted searches
- Relevant file inspection
- Minimal edits
- Targeted tests
- Limited delegation
- Avoiding repeated context
- Avoiding speculative reasoning
- Clear stopping conditions

The objective is:

> **Maximum useful work per token.**

Not:

> **Maximum tokens spent.**

---

## Reliability

AI-assisted development becomes unreliable when the agent starts guessing.

This system therefore favors:

- Evidence over assumptions
- Verification over confidence
- Small changes over large rewrites
- Root cause over symptom fixing
- Targeted investigation over broad exploration
- Completion over perpetual improvement

When evidence is insufficient, the correct behavior is to acknowledge uncertainty rather than invent an answer.

---

## When To Go Deep

Not every task deserves the same level of investigation.

### Simple Tasks

Examples:

- Rename a variable
- Change a constant
- Fix a typo
- Modify a label
- Small styling change

Use minimal investigation.

### Normal Tasks

Examples:

- Bug fixes
- Small features
- API changes
- Component changes

Investigate relevant code and run targeted verification.

### Complex Tasks

Examples:

- Architecture changes
- Large migrations
- Distributed-system bugs
- Complex state management
- Major features

Perform deeper investigation and planning.

The rule is:

> **Complexity must justify additional work.**

---

## Git Safety

Claude should protect existing work.

Before potentially destructive operations, inspect the current repository state.

Particular care should be taken with:

- Uncommitted changes
- Untracked files
- Existing diffs
- Branch state
- Destructive commands
- History rewriting

The system should never casually destroy user work.

---

## Long-Running Work

For large tasks, use durable state instead of relying entirely on conversation history.

A lightweight `progress.md` can contain:

### Objective

The overall goal.

### Completed

Work that has already been completed.

### Remaining

Work that still needs to be done.

### Decisions

Important architectural or implementation decisions.

### Known Issues

Known problems or blockers.

### Next Step

The next concrete action.

Keep this state concise.

Do not turn it into a conversation transcript.

The repository itself remains the source of truth.

---

## Philosophy

Claude Code is powerful enough to do far more work than is actually necessary.

That is both its strength and its biggest productivity risk.

The purpose of this project is not to make Claude Code do more.

It is to make Claude Code do **the right amount of work**.

A good engineering agent should be:

- Focused
- Evidence-driven
- Efficient
- Conservative with changes
- Proportional in reasoning
- Honest about uncertainty
- Protective of existing work
- Aggressive about verification
- Willing to stop

---

## Golden Rule

> **Solve the user's problem. Verify the solution. Do not create additional problems.**

Above all:

> **DO NOT TURN A SIMPLE TASK INTO A COMPLEX ONE.**

---

## Status

This repository is intended to evolve continuously as better Claude Code workflows, patterns, commands, and engineering practices are discovered.

Improvements should preserve the core philosophy:

**Less waste.**

**Less guessing.**

**Less unnecessary complexity.**

**More useful work.**

**Better verification.**

**Better results.**
