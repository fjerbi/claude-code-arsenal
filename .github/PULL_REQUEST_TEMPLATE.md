## Pull Request — Claude Code Arsenal

### What Changed

<!-- Describe the change in 1-3 sentences. -->

### Why

<!-- What problem does this solve? Reference issue numbers if applicable. -->

### Type

- [ ] New command
- [ ] New agent
- [ ] New hook / template
- [ ] Core instruction update (CLAUDE.md / AGENTS.md)
- [ ] Documentation
- [ ] Bug fix
- [ ] Other

### Checklist

- [ ] Follows Arsenal conventions (scope, evidence, verification)
- [ ] `bash scripts/validate.sh .` passes
- [ ] All cross-references are valid (CLAUDE.md ↔ AGENTS.md ↔ agents ↔ commands)
- [ ] New agents include: Contract, Protocol, Decision Rules, Guardrails
- [ ] New commands include: Trigger, Protocol, Output, Guardrails
- [ ] No breaking changes to existing commands or agents
- [ ] Documentation updated if behavior changed
- [ ] CHANGELOG.md updated

### Verification

```
Command: bash scripts/validate.sh --self
Output: [paste output]
```

### Notes

<!-- Any additional context, tradeoffs, or follow-up items. -->
