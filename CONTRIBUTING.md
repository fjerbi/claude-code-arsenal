# Contributing to Claude Code Arsenal

Thank you for contributing to Claude Code Arsenal! This document explains how to contribute effectively.

## Principles

Arsenal contributions must follow the same principles the system enforces:

1. **Minimal scope** — Every change should serve a clear purpose
2. **Evidence-based** — Claims must be backed by actual testing
3. **Verified** — All changes must pass validation before submission
4. **Backward-compatible** — Do not break existing commands, agents, or workflows

## Getting Started

1. **Fork** the repository
2. **Clone** your fork
3. Create a **feature branch**: `git checkout -b feature/my-improvement`
4. Make your changes
5. **Validate**: `bash scripts/validate.sh .`
6. **Commit** with a descriptive message
7. **Push** and open a Pull Request

## What Can You Contribute?

### New Commands

Commands live in `.claude/commands/` and must include:

```markdown
# Command Name

Goal: [one sentence]

## Trigger
[When to run this command]

## Protocol
[Ordered steps]

## Output
[Expected output format]

## Guardrails
[Safety rules]
```

### New Agents

Agents live in `.claude/agents/` and must include:

```markdown
# Agent Name

Role: [one sentence]

## Contract
**Inputs:** [what the agent receives]
**Outputs:** [what the agent produces]
**Gate:** [completion condition]
**Boundary:** [what the agent must NOT do]

## Protocol
[Ordered steps]

## Decision Rules
[Conditional behaviors]

## Guardrails
[Safety rules]
```

### Core Instruction Updates

Changes to `CLAUDE.md` or `AGENTS.md` are high-impact. They must:

- Maintain cross-references (§ references between documents)
- Not contradict existing principles
- Include rationale for the change
- Be tested against real workflows

### Documentation

Docs in `docs/` should:

- Reference the relevant AGENTS.md section
- Include actionable templates or checklists
- Stay concise — no unnecessary prose

### Hooks

Hooks in `.claude/hooks/` must:

- Be portable (bash, no exotic dependencies)
- Fail safely (set -eu)
- Produce clear output (pass/fail with context)
- Not block workflows unnecessarily

## Validation Requirements

Before submitting a PR:

```bash
# Run the validation suite
bash scripts/validate.sh .

# Verify shell scripts parse correctly
for script in scripts/*.sh .claude/hooks/*.sh; do
  bash -n "$script"
done

# Verify settings.json is valid
python3 -c "import json; json.load(open('.claude/settings.json'))"
```

All checks must pass.

## Commit Message Format

Use conventional commits:

```
feat: add new debug-memory command
fix: correct cross-reference in CLAUDE.md §12
docs: update verification contracts table
chore: update validation script for new templates
```

## Pull Request Requirements

1. Use the PR template (automatically applied)
2. Include validation output
3. Describe what changed and why
4. Note any breaking changes
5. Update CHANGELOG.md

## Code Review

Contributions are reviewed for:

- **Correctness** — Does the change work as described?
- **Scope** — Is the change bounded and focused?
- **Safety** — Does it maintain Arsenal safety guarantees?
- **Consistency** — Does it follow existing patterns?
- **Quality** — Is it well-structured and clear?

## What NOT to Do

- ❌ Don't add unnecessary complexity
- ❌ Don't break existing commands or agents
- ❌ Don't add dependencies without concrete justification
- ❌ Don't submit without running validation
- ❌ Don't make broad stylistic changes unrelated to function
- ❌ Don't weaken safety rules or guardrails

## Questions?

Open an issue for discussion before making large changes. This helps align on direction before investing implementation effort.
