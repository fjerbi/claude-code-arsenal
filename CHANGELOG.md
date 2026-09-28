# Changelog

All notable changes to Claude Code Arsenal will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- Claude Code hooks wired in `.claude/settings.json`: `guard-bash.sh` (PreToolUse — blocks destructive commands), `verify-files.sh` (PostToolUse + Stop — automatic syntax/merge-marker checks fed back to Claude), `session-context.sh` (SessionStart — auto-resume from `progress.md`)
- `/auto` command — main-thread pipeline: triage → route → delegate noisy work to cheap subagents → verify → stop
- `scripts/test-hooks.sh` hook smoke tests (`arsenal test-hooks`, CI step)
- `--compact` / `-Compact` installer flag — installs `CLAUDE_COMPACT.md` as `CLAUDE.md`

### Changed
- All commands have frontmatter (`description`, `argument-hint`) and `$ARGUMENTS`, so Claude can select them and they accept task input
- Agents and commands inline the rules they need instead of referencing `AGENTS.md` sections; researcher/validator reports are size-capped
- `orchestrator` is documented as main-thread only (`claude --agent orchestrator`) — subagents cannot spawn subagents
- Installers always install Claude Code hooks; `--no-hooks` now only skips git-hook wiring

### Fixed
- `settings.json` deny rules used an unrecognized `Bash:cmd` syntax and were never enforced; now `Bash(cmd:*)`, backed by the guard hook
- Removed non-existent settings keys `preferredEditor` and `autoApprove`
- `log-filter.sh "npm test"` (single quoted command, as documented) failed with "command not found"

## [1.0.0] — 2025-09-19

### Added

#### Core System
- `CLAUDE.md` — 30-rule operating system for Claude Code with priority ordering, adaptive reasoning, and self-review gates
- `AGENTS.md` — 20-section multi-agent execution model with complexity classification, OHTF debugging, failure budgets, TDD protocol, risk classification, and verification contracts
- `.claude/constitution.md` — Immutable principles and hard stop rules

#### Agents (6)
- `orchestrator` — Coordinates multi-agent execution with ownership boundaries
- `planner` — Decomposes tasks into dependency-ordered, verifiable steps
- `researcher` — Gathers precise facts from the repo (read-only)
- `fixer` — Resolves root causes with minimal patches using OHTF cycle
- `validator` — Verifies changes with actual command output
- `reviewer` — Reviews patches for correctness, scope, safety, and quality

#### Commands (10)
- `triage-task` — Classify complexity, scope, and risk before execution
- `plan-task` — Produce dependency-ordered execution plan
- `fix-bug` — OHTF-driven bug resolution with TDD
- `implement-feature` — TDD-driven feature implementation
- `debug-root-cause` — Hypothesis-driven root cause analysis
- `validate-change` — Risk-scaled verification
- `review-diff` — Pre-commit scope and safety review
- `review-architecture` — Detect unnecessary complexity
- `safety-review` — Security and destructive operation review
- `quality-gate` — Final completion checklist

#### Hooks (3)
- `pre-commit.sh` — Secret detection, whitespace/merge markers, debug artifact detection, large file warnings
- `pre-push.sh` — Uncommitted change check, branch safety, test runner, progress.md detection
- `post-task.sh` — Cleanup progress.md, detect debug artifacts, git status summary

#### Templates (4)
- `task-template.md` — Structured task definition with agent routing
- `pr-template.md` — Pull request description with verification evidence
- `bug-report-template.md` — OHTF-aligned bug reports with severity and blast radius
- `feature-request-template.md` — Feature requests with acceptance criteria and risk assessment

#### Documentation (8)
- `docs/workflow.md` — Standard execution sequence and complexity decision tree
- `docs/conventions.md` — Code style, change safety, multi-agent, and commit rules
- `docs/checklists.md` — Before starting, editing, committing, declaring done, and parallel dispatch
- `docs/debugging.md` — OHTF debugging protocol reference with anti-patterns
- `docs/verification.md` — Verification contracts and composable verification layers
- `docs/decisions.md` — Decision documentation guide with pre-mortem and tradeoff analysis
- `docs/handoff.md` — Agent handoff protocol with evidence chain
- `docs/preflight.md` — 10-point preflight checklist with rollback plan

#### Automation
- `scripts/install.sh` — Bash installer (project-level and global)
- `scripts/install.ps1` — PowerShell installer for Windows
- `scripts/validate.sh` — Installation integrity validator (CI-ready)
- `scripts/update.sh` — In-place updater with backup
- `.github/workflows/arsenal-validate.yml` — GitHub Actions CI pipeline

#### Community
- `CONTRIBUTING.md` — Contribution guidelines with command/agent structure requirements
- `LICENSE` — MIT License
- `CHANGELOG.md` — This file
- `.github/PULL_REQUEST_TEMPLATE.md` — PR template for Arsenal contributions

#### Configuration
- `.claude/settings.json` — Safety-hardened settings with comprehensive deny-list
- `.gitignore` — Standard exclusions for OS, editor, and temp files
