# Project Conventions

## General principles
- Prefer the smallest correct change.
- Search before patching.
- Validate with the smallest relevant command.
- Do not broaden scope without explicit need.
- Preserve existing user work.
- Prefer a narrow, evidence-backed plan over broad exploration.

## Multi-agent operating expectations
- Use the orchestrator when a task spans multiple phases or specialist roles.
- Keep each agent scoped to a single responsibility boundary.
- Parallelize only when the workstreams are genuinely independent.
- Never allow parallel branches to mutate the same files without explicit coordination.
- Preserve context across handoffs and document assumptions.

## Coding expectations
- Keep changes readable and local.
- Match existing project naming and structure.
- Prefer reusing existing utilities over introducing new abstractions.
- Do not add dependencies unless necessary.
- Keep agent tasks executable without hidden operational assumptions.

## Change safety
- No unrelated refactors.
- No speculative error handling.
- No hidden behavior changes.
- No destructive commands without explicit confirmation.
- No silent merge of parallel branches without validation evidence.

## Verification
- Run a focused check after the change.
- Validate each independent workstream before claiming the combined result is ready.
- Report actual evidence, not assumptions.
- Stop once the behavior is validated.
