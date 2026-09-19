# Review Architecture

Goal: detect unnecessary complexity and risky design growth.

Steps:
1. Inspect whether the change is proportional to the task.
2. Check for new abstraction layers or speculative complexity.
3. Confirm the code matches the existing architecture and conventions.
4. Identify if the solution is simple, local, and maintainable.
5. Recommend the smallest simpler alternative if needed.

Guardrails:
- Prefer simple, direct designs over abstract frameworks.
- Do not approve unnecessary complexity.
- Favor maintainability and clarity over cleverness.
