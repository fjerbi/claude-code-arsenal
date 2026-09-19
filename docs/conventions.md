# Project Conventions

## Code Style

- Follow existing project conventions. Match indentation, naming, and formatting.
- Do not enforce personal preferences over project standards.
- WHEN uncertain about style → inspect 2-3 similar files for the pattern.

## Change Safety

- No unrelated refactors.
- No speculative error handling.
- No hidden behavior changes.
- No destructive commands without explicit confirmation.
- No silent merge of parallel branches without validation evidence.

## Multi-Agent Rules

- Keep each agent scoped to a single responsibility.
- Parallelize only genuinely independent workstreams.
- NEVER allow parallel branches to mutate the same files without coordination.
- Preserve context across handoffs and document assumptions.

## Naming

- Use descriptive, consistent names matching project conventions.
- Avoid abbreviations unless project-standard.

## Error Handling

- Follow existing error handling patterns.
- Do not add speculative error handling.
- Handle errors at the appropriate level.

## Testing

- Follow existing test patterns, framework, and locations.
- Apply TDD when fixing bugs or adding features (AGENTS.md §6).
- NEVER delete or relax existing tests to make a suite pass.

## Dependencies

- NEVER add dependencies without concrete need.
- Check existing dependencies and standard library first.

## Verification

- Run focused verification after every change.
- Validate each workstream independently before merging.
- Report actual evidence, not assumptions.
- Stop once behavior is validated.

## Commits

- Use conventional commit format when the project uses it.
- Keep messages concise and descriptive.
- Reference issue numbers when applicable.
- NEVER commit without verification passing.
