
```text
 ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
██║     ██║     ███████║██║   ██║██║  ██║█████╗
██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝
╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
 ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝

 ██████╗ ██████╗ ██████╗ ███████╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝
██║     ██║   ██║██║  ██║█████╗
██║     ██║   ██║██║  ██║██╔══╝
╚██████╗╚██████╔╝██████╔╝███████╗
 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝

 █████╗ ██████╗ ███████╗███████╗███╗   ██╗ █████╗ ██     
██╔══██╗██╔══██╗██╔════╝██╔════╝████╗  ██║██╔══██╗██║     
███████║██████╔╝███████╗█████╗  ██╔██╗ ██║███████║██║     
██╔══██║██╔══██╗╚════██║██╔══╝  ██║╚██╗██║██╔══██║██║     
██║  ██║██║  ██║███████║███████╗██║ ╚████║██║  ██║███████╗
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
```

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

## Benchmarking

The goal of Claude Code Arsenal is not simply to reduce token usage.

The real objective is:

> **Maximize useful engineering work per token while maintaining or improving correctness.**

A smaller token count is only an improvement if the resulting work remains correct, reliable, and appropriately verified.

### Expected Impact

There is no universal token-saving percentage. Actual results depend on:

- Repository size
- Task complexity
- Model
- Tool availability
- Existing project instructions
- Number of files involved
- Test suite size
- Amount of ambiguity in the task

Reasonable target ranges are:

| Task Type | Baseline | With Arsenal | Expected Reduction |
|---|---:|---:|---:|
| Tiny edit | 3–8k | 2–5k | ~20–40% |
| Simple bug fix | 10–30k | 6–18k | ~25–45% |
| Normal feature | 20–60k | 15–45k | ~15–30% |
| Difficult debugging | 40–120k | 30–90k | ~10–30% |
| Large refactor | 80–250k+ | 70–220k+ | ~5–20% |

These are target ranges, not measured guarantees.

The system should not sacrifice correctness simply to reduce token usage.

---

## What Should Improve?

The largest expected improvement should come from reducing unnecessary work.

### Before

Typical inefficient behavior:

1. Explore the repository broadly
2. Read unrelated files
3. Search repeatedly
4. Consider hypothetical problems
5. Spawn unnecessary agents
6. Make broad changes
7. Run excessive tests
8. Discover unrelated issues
9. Fix unrelated issues
10. Continue after the task is already complete

### After

The intended behavior is:

1. Understand the task
2. Define the scope
3. Search only where necessary
4. Inspect relevant evidence
5. Establish the root cause
6. Make the smallest reliable change
7. Run targeted verification
8. Stop when the task is complete

---

## Example Benchmark

A hypothetical bug-fix benchmark might look like this:

| Metric | Baseline | Arsenal |
|---|---:|---:|
| Files inspected | 18 | 5 |
| Search operations | 12 | 4 |
| Tool calls | 35 | 15 |
| Test commands | 5 | 1–2 |
| Context consumed | 35k | 18k |
| Lines changed | 140 | 25 |
| Unrelated changes | 3 | 0 |
| Retries | 4 | 1 |

The important result is not simply that fewer tokens were used.

The important result is that the same task was completed with:

- Less irrelevant exploration
- Fewer unnecessary tool calls
- Fewer unrelated changes
- Fewer retries
- Smaller implementation scope
- Equivalent or better verification

---

## Recommended Benchmark

To properly evaluate Claude Code Arsenal, create a benchmark suite containing approximately 20 representative tasks:

- 5 trivial tasks
- 5 bug fixes
- 5 feature tasks
- 3 refactoring tasks
- 2 difficult investigations

Run every task twice.

### A — Baseline

Use:

- Claude Code
- Normal project instructions
- No Arsenal instructions

### B — Arsenal

Use:

- Claude Code
- The same project
- The same task
- Claude Code Arsenal instructions

Keep the environment as identical as possible.

---

## Metrics

Record the following for every run:

| Metric | Description |
|---|---|
| Input tokens | Tokens sent to the model |
| Output tokens | Tokens generated by the model |
| Total tokens | Input + output tokens |
| Tool calls | Number of tool operations |
| Files read | Number of files inspected |
| Files changed | Number of modified files |
| Tests executed | Number of test/check commands |
| Retries | Repeated or failed attempts |
| Unrelated changes | Changes outside task scope |
| Completion | Whether the task was successfully completed |
| Correctness | Whether the implementation behaves correctly |
| Verification | Whether appropriate verification passed |
| Time | Total task duration |

---

## Token Reduction

Calculate token reduction using:

**Token Reduction = ((Baseline Tokens - Arsenal Tokens) / Baseline Tokens) × 100**

Example:

Baseline:

20,000 tokens

Arsenal:

14,000 tokens

Result:

**30% token reduction**

---

## Efficiency

Token reduction alone is not enough.

A system that uses fewer tokens but produces worse code is not more efficient.

A better measure is:

**Engineering Efficiency = Successful Task Completion / Total Tokens**

Track correctness and task completion alongside token usage.

---

## Target Improvements

A successful implementation should aim for approximately:

| Metric | Target |
|---|---:|
| Token usage | ↓ 15–35% |
| Unnecessary tool calls | ↓ 25–50% |
| Unrelated file changes | ↓ 50%+ |
| Repeated attempts | ↓ 30–60% |
| Task completion | Same or better |
| Correctness | Same or better |
| Verification quality | Same or better |

These targets are benchmarks to investigate, not guaranteed results.

---

## Important Trade-Off

Claude Code Arsenal should never optimize for token savings at the expense of correctness.

The priority is:

1. Correctness
2. Task completion
3. Security
4. Appropriate verification
5. Minimal scope
6. Token efficiency
7. Speed
8. Elegance

The objective is not:

> "Use as few tokens as possible."

The objective is:

> **Use no more tokens, tools, exploration, or reasoning than the task actually requires.**

---

## Benchmark Philosophy

The ideal result is not simply:

**Less tokens.**

It is:

**Less wasted work + equal or better correctness + equal or better verification.**

That is the standard Claude Code Arsenal should be measured against.

