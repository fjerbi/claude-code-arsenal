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

 █████╗ ██████╗ ███████╗███████╗███╗   ██╗ █████╗ ██╗
██╔══██╗██╔══██╗██╔════╝██╔════╝████╗  ██║██╔══██╗██║
███████║██████╔╝███████╗█████╗  ██╔██╗ ██║███████║██║
██╔══██║██╔══██╗╚════██║██╔══╝  ██║╚██╗██║██╔══██║██║
██║  ██║██║  ██║███████║███████╗██║ ╚████║██║  ██║███████╗
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
```

# Claude Code Arsenal

> A disciplined operating system for Claude Code — built to maximize engineering efficiency, minimize wasted tokens, prevent hallucinations, and keep AI-assisted development focused on the actual task.

[![Arsenal Validate](https://github.com/fjerbi/claude-code-arsenal/actions/workflows/arsenal-validate.yml/badge.svg)](https://github.com/fjerbi/claude-code-arsenal/actions/workflows/arsenal-validate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Quick Start

### One-Command Install (into your project)

**Bash (Linux / macOS / WSL):**

```bash
curl -fsSL https://raw.githubusercontent.com/fjerbi/claude-code-arsenal/main/scripts/install.sh | bash -s -- /path/to/your/project
```

**PowerShell (Windows):**

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/fjerbi/claude-code-arsenal/main/scripts/install.ps1))) -TargetPath "C:\path\to\your\project"
```

Both one-liners auto-fetch a full checkout to a temp directory and clean up after themselves — no manual clone needed.

**Or clone & install manually:**

```bash
git clone https://github.com/fjerbi/claude-code-arsenal.git
cd claude-code-arsenal
bash scripts/install.sh /path/to/your/project        # bash
.\scripts\install.ps1 -TargetPath "C:\path\to\your\project"   # PowerShell
```

### Global Install

```bash
# Bash — one-liner or from a local clone
curl -fsSL https://raw.githubusercontent.com/fjerbi/claude-code-arsenal/main/scripts/install.sh | bash -s -- --global
```

```powershell
# PowerShell — one-liner
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/fjerbi/claude-code-arsenal/main/scripts/install.ps1))) -Global
```

This installs the core rules to your Claude Code user-level config so every project benefits from the operating system.

### Validate Installation

```bash
bash scripts/validate.sh /path/to/your/project
```

---

## What Is This?

Claude Code Arsenal is a collection of instructions, workflows, conventions, and tools designed to make Claude Code work like a **disciplined senior software engineer**.

The goal is simple: **Get the right result with the least unnecessary work.**

Instead of letting Claude:
- Explore endlessly and read irrelevant files
- Overthink simple tasks and spawn unnecessary agents
- Rewrite working code and introduce unnecessary abstractions
- Repeat failed actions and consume context on irrelevant details

Arsenal enforces:

> **Search → Identify → Inspect → Reason → Change → Verify → Stop**

---

## Core Principles

| # | Principle | What It Means |
|---|---|---|
| 1 | **Task First** | Understand the objective before acting. No unnecessary clarification. |
| 2 | **Minimum Necessary Work** | Every action must serve the task. |
| 3 | **Evidence Over Assumptions** | Inspect the repo instead of guessing. |
| 4 | **Minimal Changes** | Solve with the smallest reliable change. |
| 5 | **Proportional Reasoning** | Simple tasks stay simple. Complex tasks get deeper investigation. |
| 6 | **Targeted Verification** | Run the smallest test that provides real confidence. |
| 7 | **No Infinite Loops** | Stop → Reassess → Update hypothesis after repeated failures. |
| 8 | **No Hallucination** | Never invent files, APIs, functions, dependencies, or test results. |
| 9 | **Protect User Work** | Existing uncommitted changes are user-owned. |
| 10 | **Stop When Done** | Once verified, **STOP**. Don't manufacture additional work. |

---

## Repository Structure

```
claude-code-arsenal/
├── CLAUDE.md                          # Core operating instructions (30 rules)
├── AGENTS.md                          # Multi-agent execution model (20 sections)
├── README.md                          # This file
├── CONTRIBUTING.md                    # Contribution guidelines
├── CHANGELOG.md                       # Release history
├── LICENSE                            # MIT License
│
├── .claude/
│   ├── constitution.md                # Immutable principles
│   ├── settings.json                  # Project settings & safety deny-list
│   │
│   ├── agents/                        # Specialized agent definitions
│   │   ├── orchestrator.md            # Coordinates multi-agent execution
│   │   ├── planner.md                 # Decomposes tasks into plans
│   │   ├── researcher.md             # Gathers evidence (read-only)
│   │   ├── fixer.md                   # Resolves root causes with minimal patches
│   │   ├── validator.md              # Verifies changes with actual output
│   │   └── reviewer.md               # Reviews patches for quality & safety
│   │
│   ├── commands/                      # Reusable workflow commands
│   │   ├── triage-task.md             # Classify & scope before execution
│   │   ├── plan-task.md               # Produce dependency-aware plan
│   │   ├── fix-bug.md                 # OHTF-driven bug resolution
│   │   ├── implement-feature.md       # TDD-driven feature implementation
│   │   ├── debug-root-cause.md        # Hypothesis-driven root cause analysis
│   │   ├── validate-change.md         # Risk-scaled verification
│   │   ├── review-diff.md             # Pre-commit scope & safety review
│   │   ├── review-architecture.md     # Detect unnecessary complexity
│   │   ├── safety-review.md           # Security & destructive-op review
│   │   └── quality-gate.md            # Final completion checklist
│   │
│   ├── hooks/                         # Safety hooks
│   │   ├── pre-commit.sh              # Secret detection, whitespace, debug artifacts
│   │   ├── pre-push.sh                # Validation before push
│   │   └── post-task.sh               # Post-task cleanup
│   │
│   └── templates/                     # Reusable templates
│       ├── task-template.md           # Structured task definition
│       ├── pr-template.md             # Pull request description
│       ├── bug-report-template.md     # OHTF-aligned bug reports
│       └── feature-request-template.md # Feature requests with acceptance criteria
│
├── docs/                              # Extended documentation
│   ├── workflow.md                    # Standard execution sequence
│   ├── conventions.md                 # Code style & change safety rules
│   ├── checklists.md                  # Pre-start through completion checklists
│   ├── debugging.md                   # OHTF debugging protocol reference
│   ├── verification.md               # Verification contracts reference
│   ├── decisions.md                   # Decision documentation guide
│   ├── handoff.md                     # Agent handoff protocol reference
│   └── preflight.md                   # Pre-task preflight checklist
│
├── scripts/                           # Automation scripts
│   ├── install.sh                     # Install Arsenal into a project (Bash)
│   ├── install.ps1                    # Install Arsenal into a project (PowerShell)
│   ├── validate.sh                    # Validate Arsenal installation integrity
│   └── update.sh                      # Update Arsenal in a project
│
└── .github/
    ├── PULL_REQUEST_TEMPLATE.md       # PR template for Arsenal contributions
    └── workflows/
        └── arsenal-validate.yml       # CI validation pipeline
```

---

## Commands Reference

Commands are invoked by Claude Code as structured workflows. Each command has a **trigger**, **protocol**, **output format**, and **guardrails**.

| Command | Purpose | When to Use |
|---|---|---|
| `triage-task` | Classify complexity, scope, and risk | Before any implementation |
| `plan-task` | Create dependency-ordered execution plan | When complexity ≥ COMPLEX |
| `fix-bug` | OHTF-driven bug resolution | Any bug fix |
| `implement-feature` | TDD-driven feature implementation | New features |
| `debug-root-cause` | Hypothesis-driven root cause analysis | Unknown or hard-to-reproduce bugs |
| `validate-change` | Risk-scaled verification | After any code change |
| `review-diff` | Scope & safety review of current diff | Before committing |
| `review-architecture` | Detect unnecessary complexity | Structural or abstraction changes |
| `safety-review` | Security & destructive operation review | Security-sensitive changes |
| `quality-gate` | Final completion checklist | Before declaring task done |

---

## Agents Reference

Agents are specialized roles with strict contracts, boundaries, and guardrails.

| Agent | Role | Boundary |
|---|---|---|
| **Orchestrator** | Coordinates multi-agent execution | Does not write production code |
| **Planner** | Decomposes tasks into dependency-ordered steps | Does not execute the plan |
| **Researcher** | Gathers precise facts from the repo | Read-only — does not modify code |
| **Fixer** | Resolves root causes with minimal patches | Modifies only assigned files |
| **Validator** | Verifies changes with actual command output | Does not modify production code |
| **Reviewer** | Reviews patches for correctness, scope, safety | Does not rewrite the implementation |

---

## Complexity Classification

Every task is classified before execution:

| Level | Scope | Protocol |
|---|---|---|
| **TRIVIAL** | Single symbol, constant, typo, label | Act immediately. No planning. |
| **NORMAL** | Scoped bug fix, small feature, single-module | Investigate → implement → verify. |
| **COMPLEX** | Multi-file, cross-module, API contract | Plan → phase → implement → verify each phase. |
| **CRITICAL** | Security, data integrity, architecture, public API | Deep analysis → plan → phased execution → comprehensive verification. |

---

## Verification Contracts

Changes are verified proportionally to their risk:

| Change Type | Required Verification |
|---|---|
| Type / interface | Type check (tsc, mypy, cargo check) |
| API / contract | Integration test |
| Business logic | Unit test for changed behavior |
| UI / visual | Visual verification or screenshot |
| Data / schema | Migration test + rollback check |
| Security-sensitive | Security audit + reviewer |
| Configuration | Smoke test |
| Dependency | Build + existing test suite |

---

## Safety & Anti-Hallucination

Arsenal enforces strict safety rules:

- ❌ No invented APIs, files, or dependencies
- ❌ No fabricated test results or command output
- ❌ No speculative refactors or silent scope expansion
- ❌ No completion claims without fresh verification evidence
- ❌ No secrets, credentials, or tokens in commits
- ❌ No destructive git operations (force push, reset --hard, clean -fd)
- ✅ Evidence-based execution with explicit validation
- ✅ Failure budget: 3 attempts max, then stop and report

---

## How To Use It

Write short, precise task descriptions:

```
Fix the authentication bug in src/auth/session.ts.

Expected behavior:
- Sessions expire after 7 days.
- Refreshing a session must not extend expiration.

Constraints:
- Smallest reliable change.
- Do not refactor unrelated code.

Verification:
- Run the session tests.

Stop when verified.
```

Arsenal handles the engineering discipline. Your prompt only needs to describe the work.

### Recommended Task Format

For structured tasks, use the [task template](.claude/templates/task-template.md):

| Section | Purpose |
|---|---|
| **Objective** | What needs to be done |
| **Scope** | In/out of scope, relevant files |
| **Context** | Current state, constraints, risks |
| **Agent routing** | Which agent role handles this |
| **Work plan** | Ordered steps |
| **Acceptance criteria** | Checklist for completion |

---

## Token Efficiency

Arsenal targets efficiency without sacrificing correctness:

| Metric | Target |
|---|---|
| Token usage | ↓ 15–35% |
| Unnecessary tool calls | ↓ 25–50% |
| Unrelated file changes | ↓ 50%+ |
| Repeated attempts | ↓ 30–60% |
| Task completion | Same or better |
| Correctness | Same or better |

The objective is not "use fewer tokens" — it is:

> **Use no more tokens, tools, exploration, or reasoning than the task actually requires.**

---

## CI/CD Integration

Arsenal includes a GitHub Actions workflow that validates installation integrity:

```yaml
# Add to your project's .github/workflows/
name: Arsenal Validate
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: bash scripts/validate.sh .
```

---

## Configuration

Arsenal ships with sensible defaults in [`.claude/settings.json`](.claude/settings.json):

- **Allowed tools:** Bash, Read, Write, Edit, MultiEdit, Glob, Grep, Task
- **Denied operations:** `rm -rf /`, `sudo`, pipe-to-shell, force push, history reset, destructive filesystem operations
- **Telemetry:** Disabled
- **Auto-approve:** Disabled (safety first)

Customize `settings.json` for your project's needs while preserving the safety deny-list.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. In brief:

1. Fork and create a feature branch
2. Follow Arsenal conventions (scope, evidence, verification)
3. Run `bash scripts/validate.sh .` before submitting
4. Use the PR template

---

## License

[MIT](LICENSE)

---

## Philosophy

Claude Code is powerful enough to do far more work than is actually necessary. That is both its strength and its biggest productivity risk.

Arsenal does not make Claude Code do **more**. It makes Claude Code do **the right amount of work**.

> **Less waste. Less guessing. Less unnecessary complexity.**
> **More useful work. Better verification. Better results.**

### Golden Rule

> **Solve the user's problem. Verify the solution. Do not create additional problems.**

> **DO NOT TURN A SIMPLE TASK INTO A COMPLEX ONE.**
