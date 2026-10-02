# PR Review Checklist

The source of truth for reviewing {{PROJECT_NAME}} PRs. Humans use it, and so does the `code-reviewer` subagent (`.claude/agents/code-reviewer.md`). Skip the sections that don't apply to the diff.

<!-- GUIDE: Turn each AGENTS.md rule and ADR into a checkable item. Link the ADRs. Drop sections that don't apply. -->

## Architecture & Patterns
- [ ] Does the code follow {{primary pattern}}? ({{adr link}})

## {{Security / Data scoping / Auth}}
- [ ] {{item}}

## Type Safety
- [ ] {{item}}

## Generated Files
- [ ] `{{generated path}}` was not manually edited
- [ ] If {{source}} changed, `{{CODEGEN_COMMAND}}` was run

## Database Changes
- [ ] {{migration items}}

## Tests
- [ ] New behaviour has tests; `{{TEST_COMMAND}}` passes

## Docs
- [ ] If the change alters architecture, a layer boundary or a convention, are `docs/architecture.md`, the relevant `AGENTS.md`, or a new ADR updated?

## Review Etiquette
- Be constructive and specific; suggest code when proposing changes
- Focus on architecture and logic. CI and hooks handle formatting and linting
