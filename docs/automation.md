# Claude Code Arsenal — Automation & Token Optimization Guide

This guide explains how to run Claude Code with maximum automation, sub-second execution efficiency, and minimal token consumption.

---

## 1. Token-Frugal Execution

Context window space is finite and expensive. Arsenal provides tools to trim context usage by up to **80%**.

### A. Compact Rules (`CLAUDE_COMPACT.md`)
For routine coding sessions where full system prompts are too heavy, switch to `CLAUDE_COMPACT.md`. It retains strict non-negotiable guardrails (Scope control, Evidence requirement, OHTF, Stop-when-done) in ~2.5KB of dense markdown instead of ~10KB.

### B. Output Log Sanitization (`log-filter.sh` / `log-filter.ps1`)
Raw test suites (`pytest`, `npm test`, `cargo test`) often output hundreds of lines of passing checks and warnings.
Using `log-filter.sh` strips success noise and feeds **only** failing assertions and stack traces to Claude:

```bash
# Bash
bash scripts/log-filter.sh "npm test"

# PowerShell
.\scripts\log-filter.ps1 -Command "pytest"
```

---

## 2. Fast-Path Pre-Flight Checks (`fast-check`)

Instead of wasting 5 to 10 sequential LLM tool calls (`Grep`, `Read`, `Glob`, `Task`) to check project health or syntax:

```bash
# Sub-second deterministic local check
bash scripts/fast-check.sh .
```

`fast-check` inspects `.claude/settings.json` validity, shell syntax across scripts, git conflict markers, and returns a single status result in under **300ms**.

---

## 3. Unified Arsenal CLI (`arsenal.sh` / `arsenal.ps1`)

Manage Arsenal features from a single entrypoint, on bash or PowerShell:

| Bash | PowerShell | Action |
|---|---|---|
| `bash scripts/arsenal.sh check .` | `.\scripts\arsenal.ps1 check .` | Run sub-second pre-flight health check |
| `bash scripts/arsenal.sh validate .` | `.\scripts\arsenal.ps1 validate .` | Run complete Arsenal integrity validator |
| `bash scripts/arsenal.sh install /path` | `.\scripts\arsenal.ps1 install C:\path` | Install Arsenal into a target project |
| `bash scripts/arsenal.sh filter "<cmd>"` | `.\scripts\arsenal.ps1 filter "<cmd>"` | Execute command with token log filtering |

---

## 4. Subagent Model Routing

Each role in `.claude/agents/*.md` is a registered subagent with `model` and `tools` pinned in its frontmatter, dispatched via the Task tool (`subagent_type: "<role>"`). Read-only, high-volume roles run on a fast/cheap model; roles that reason about multi-file changes run on the main model:

| Subagent Role | Model | Tools | Reason |
|---|---|---|---|
| **Researcher** | Haiku | Read, Grep, Glob, Bash | Fast symbol grep and indexing; read-only |
| **Validator** | Haiku | Read, Bash, Grep, Glob | Log checking and unit test verification; read-only |
| **Planner** | Sonnet | Read, Grep, Glob | Dependency-ordered plans; read-only |
| **Reviewer** | Sonnet | Read, Grep, Glob, Bash | Diff review against objective; read-only |
| **Fixer** | Sonnet | Read, Edit, MultiEdit, Write, Bash, Grep, Glob | Multi-file reasoning, applies patches |
| **Orchestrator** | Sonnet | Read, Grep, Glob, Bash, Task | Coordinates the above; does not edit directly |

Only dispatch a subagent when it provides genuine advantage (CLAUDE.md §13) — for TRIVIAL/NORMAL tasks, act directly instead of paying dispatch overhead.

---

## 5. Automated Git Hook Setup

When installing Arsenal using `scripts/install.sh`, Arsenal automatically installs `.git/hooks/pre-commit` and `.git/hooks/pre-push` into target Git repositories.
To skip hook installation, pass `--no-hooks`:

```bash
bash scripts/install.sh /path/to/project --no-hooks
```
