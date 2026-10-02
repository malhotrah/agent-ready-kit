# File catalog

What each generated file is for, when to generate it, and which template to start from. Paths are relative to the target repo root.

| Output path | Template | Generate when | Must contain |
|-------------|----------|---------------|--------------|
| `AGENTS.md` | `AGENTS.root.md` | Always | Project overview (stack, dev vs prod topology), area pointers, docs map, commands, cross-cutting rules, PR basics, gotchas, key files |
| `<area>/AGENTS.md` | `AGENTS.area.md` | For each area chosen in Round A | Area patterns with real base classes and paths, rules, the verify command |
| `CLAUDE.md` (root) | `CLAUDE.md` | Always (if Claude Code is in use) | `@AGENTS.md`, plus Claude-only notes (subagents, commands, hooks) if any |
| `<area>/CLAUDE.md` | `CLAUDE.md` | Only if the user wants Claude to auto-load nested rules | `@AGENTS.md` |
| `docs/README.md` | `docs/README.md` | When generating any engineering doc | Reading order, how to keep the docs alive |
| `docs/architecture.md` | `docs/architecture.md` | Default yes | System context diagram, dev/prod table, layers table, **worked trace of one real request**, cross-cutting concerns, "where do I find…" table |
| `docs/onboarding.md` | `docs/onboarding.md` | Default yes | Prerequisites table with check commands, install/run, reading order, first change walkthrough, agent tooling table |
| `docs/testing.md` | `docs/testing.md` | If tests exist | Commands table (all, by name, single file, single test), layout, fixtures, conventions |
| `docs/glossary.md` | `docs/glossary.md` | If the domain has its own vocabulary | Term, meaning, scope, code location table |
| `docs/review-checklist.md` | `docs/review-checklist.md` | Default yes | Checklist sections derived from AGENTS.md rules and the ADRs |
| `docs/adr/0000-template.md` | `docs/adr/0000-template.md` | With ADRs | The template |
| `docs/adr/NNNN-<slug>.md` | `docs/adr/0000-template.md` | One per decision confirmed in Round C | Context, decision with real file refs, consequences, alternatives |
| `.claude/settings.json` | `claude/settings.json` | If permissions or hooks chosen | Allow and deny lists, hook wiring for the chosen hooks only |
| `.claude/hooks/block-generated-edits.js` | `claude/hooks/block-generated-edits.js` | If there are never-edit paths and the hook was chosen | The `PROTECTED` regex list and a message naming the regenerate command |
| `.claude/hooks/format-on-edit.js` | `claude/hooks/format-on-edit.js` | If formatters exist and the hook was chosen | A `FORMATTERS` map from extension to the confirmed formatter command |
| `.claude/agents/code-reviewer.md` | `claude/agents/code-reviewer.md` | If chosen | Points at the checklist, with repo-specific "check especially" bullets |
| `.claude/agents/test-runner.md` | `claude/agents/test-runner.md` | If chosen and tests exist | The area-to-test-command mapping, codegen-first rule, root-cause fixing |
| `.claude/commands/onboard.md` | `claude/commands/onboard.md` | If chosen | Focus areas, a real request per area to trace, rules that bite newcomers |
| `.claude/commands/trace.md` | `claude/commands/trace.md` | If chosen | The repo's real layers in order, with glob hints for each |
| `.github/copilot-instructions.md` | `other/copilot-instructions.md` | If Copilot chosen | Pointer to AGENTS.md plus the top 5 rules |
| `.cursor/rules/agents.mdc` | `other/cursor-rule.mdc` | If Cursor chosen | `alwaysApply: true` pointer to AGENTS.md |

## Placeholder conventions in templates

- `{{UPPER_SNAKE}}` is a value you must fill from Phase 1 findings or interview answers.
- `<!-- GUIDE: … -->` is an instruction to you. Delete it from the output.
- A section marked `<!-- OPTIONAL -->` should be dropped entirely if it doesn't apply. Never leave a section empty or "TBD".

## settings.json placeholder

`claude/settings.json` is valid JSON with `"{{…}}"` string placeholders. Expand `"{{ALLOW_COMMANDS}}"` into one array entry per confirmed command (for example `"Bash(npm test:*)"`), and remove the hook blocks the user didn't choose.
