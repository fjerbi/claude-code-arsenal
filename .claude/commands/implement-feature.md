---
description: Implement a feature or enhancement with minimal scope, existing patterns, and TDD where available.
argument-hint: <feature description and acceptance criteria>
---

# Implement Feature

Goal: add requested functionality with minimal, correct scope.

Feature: $ARGUMENTS

## Trigger

Run WHEN the task is a new feature or enhancement.

## Protocol

1. Clarify behavior and acceptance criteria.
2. Locate the relevant module and existing patterns (targeted search; `researcher` subagent only if the area is unknown and broad).
3. Assess blast radius: LOCAL (one function/config) / MODULE (shared API or utility) / SYSTEM (architecture, security, schema, public API).
4. TDD when the project has a test framework: test for expected behavior → minimum code to pass → refactor without breaking it.
5. Multi-file with independent parts → one `fixer` subagent per part, non-overlapping file ownership, launched in one message.
6. Verify scaled to risk: LOCAL → unit/smoke; MODULE → integration + type check; SYSTEM → full suite + type check + `reviewer`.
7. Report with actual output.

## Evidence Required

- Feature behaves as specified.
- Tests pass with actual output.
- No regressions.

## Guardrails

- Prefer existing patterns and utilities.
- NEVER add speculative architecture.
- NEVER expand scope beyond the feature.
- NEVER fabricate APIs or dependencies.
