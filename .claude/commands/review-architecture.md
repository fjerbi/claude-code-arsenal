# Review Architecture

Goal: detect unnecessary complexity and risky design.

## Trigger

Run WHEN a change introduces new abstractions, patterns, or structural changes.

## Protocol

1. Is the change proportional to the task?
2. Are new abstraction layers justified by concrete need?
3. Does the code match existing architecture and conventions?
4. Is the solution simple, local, and maintainable?
5. Could a simpler alternative achieve the same result?

## Decision Rules

- WHEN abstraction is justified → ACCEPT with note.
- WHEN simpler alternative exists → REVISE: recommend simpler approach.
- WHEN unnecessary complexity detected → BLOCK: explain why.

## Guardrails

- Prefer simple, direct designs over abstract frameworks.
- NEVER approve unnecessary complexity.
- Favor maintainability and clarity over cleverness.
