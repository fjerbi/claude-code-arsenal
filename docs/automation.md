# Claude Code Arsenal — Automation & Token Optimization Guide

This guide explains how to run Claude Code with maximum automation, sub-second execution efficiency, and minimal token consumption.

---

## 0. Claude Code Hooks (Zero-Token Automation)

Hooks are wired in `.claude/settings.json` and run deterministically — Claude spends no tokens or tool calls on them. They are silent on success and speak only when something is wrong.

| Hook | Event | What it does |
|---|---|---|
| `guard-bash.sh` | `PreToolUse` (Bash) | Blocks destructive commands before they run: `sudo`, `rm -rf /` or `~`, force push (incl. `+refspec`), `--no-verify`, `git reset --hard`, `git clean -f`, `git checkout .` / `git restore .`, `curl … \| sh`, `mkfs`, `dd of=/dev/…`, `find / -delete`, fork bombs. Pure bash, no forks. |
| `verify-files.sh edit` | `PostToolUse` (Write/Edit/MultiEdit) | Syntax-checks the file just written (shell, JSON, Python, JS) and scans for merge markers. Errors are fed straight back to Claude. |
| `verify-files.sh stop` | `Stop` | Re-checks every changed/untracked file before Claude finishes — catches files changed via Bash. Blocks at most once per stop (loop-safe). |
| `session-context.sh` | `SessionStart` | If `progress.md` exists, injects it so long-running work resumes without a tool call. Otherwise prints nothing. |

Disable the guard for a session by setting `"ARSENAL_GUARD": "off"` in `.claude/settings.local.json` → `env`.

Verify the hooks: `bash scripts/test-hooks.sh .` (also runs in CI).

### `/auto` — Hands-Off Pipeline

`/auto <task>` triages the task and routes it: TRIVIAL/NORMAL are done inline; COMPLEX runs `researcher → planner → parallel fixers → validator`; CRITICAL adds `reviewer` and pauses for plan approval. Subagents are dispatched only when they keep bulk output (broad searches, long test logs) out of the main context. Subagents cannot spawn subagents, so orchestration lives in this main-thread command; the `orchestrator` agent is for `claude --agent orchestrator` sessions only.

---

## 1. Token-Frugal Execution

Context window space is finite and expensive. Arsenal provides tools to trim context usage by up to **80%**.

### A. Compact Rules (`CLAUDE_COMPACT.md`)
For routine coding sessions where full system prompts are too heavy, switch to `CLAUDE_COMPACT.md`. It retains strict non-negotiable guardrails (Scope control, Evidence requirement, OHTF, Stop-when-done) in ~2KB of dense markdown instead of ~10KB. Install it as `CLAUDE.md` directly with `bash scripts/install.sh /path --compact` (PowerShell: `-Compact`).

Agents and commands are self-contained — they inline the rules they need instead of pointing at `AGENTS.md`, so a cold-started subagent never has to read the 14KB reference. Researcher and validator reports are capped (~40 lines, one line on PASS) because subagent output lands in the main context.

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
| `bash scripts/arsenal.sh test-hooks .` | `.\scripts\arsenal.ps1 test-hooks .` | Smoke-test the Claude Code hooks |

---

## 4. Subagent Model Routing

Each role in `.claude/agents/*.md` is a registered subagent with `model` and `tools` pinned in its frontmatter, dispatched via the Task tool (`subagent_type: "<role>"`). Read-only, high-volume roles run on a fast/cheap model; roles that reason about multi-file changes run on the main model:

| Subagent Role | Model | Tools | Reason |
|---|---|---|---|
| **Researcher** | Sonnet | Read, Grep, Glob, Bash | Fast symbol grep and indexing; read-only |
| **Validator** | Sonnet | Read, Bash, Grep, Glob | Log checking and unit test verification; read-only |
| **Planner** | Sonnet | Read, Grep, Glob | Dependency-ordered plans; read-only |
| **Reviewer** | Sonnet | Read, Grep, Glob, Bash | Diff review against objective; read-only |
| **Fixer** | Sonnet | Read, Edit, MultiEdit, Write, Bash, Grep, Glob | Multi-file reasoning, applies patches |
| **Orchestrator** | Sonnet | Read, Grep, Glob, Bash, Task | Main-thread only (`claude --agent orchestrator`); in normal sessions use `/auto` |

Only dispatch a subagent when it provides genuine advantage (CLAUDE.md §13) — for TRIVIAL/NORMAL tasks, act directly instead of paying dispatch overhead.

---

## 5. Automated Git Hook Setup

When installing Arsenal using `scripts/install.sh`, Arsenal automatically installs `.git/hooks/pre-commit` and `.git/hooks/pre-push` into target Git repositories.
To skip git hook wiring, pass `--no-hooks` (Claude Code hooks are always installed, since `settings.json` references them):

```bash
bash scripts/install.sh /path/to/project --no-hooks
```
