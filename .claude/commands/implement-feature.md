# Implement Feature

Goal: add requested functionality with minimal, correct scope.

## Trigger

Run WHEN the task is a new feature or enhancement.

## Protocol

1. Clarify behavior and acceptance criteria.
2. Locate relevant module and existing patterns.
3. Assess blast radius (AGENTS.md §7).
4. Apply TDD when project supports it (AGENTS.md §6):
   - Write test for expected behavior.
   - Implement minimum code to pass.
   - Refactor without breaking tests.
5. Run verification scaled to risk level (AGENTS.md §12).
6. Report with actual output.

## Evidence Required

- Feature behaves as specified.
- Tests pass with actual output.
- No regressions.

## Guardrails

- Prefer existing patterns and utilities.
- NEVER add speculative architecture.
- NEVER expand scope beyond the feature.
- NEVER fabricate APIs or dependencies.
