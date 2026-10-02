# Best practices for agent-facing repo files

These are the rules the generated files must follow. Each one exists because agents read these files on **every** task, so noise costs tokens and attention, and errors get copied.

## Content

1. **Commands first.** An agent's most frequent question is "how do I run, test or lint this?" Put the exact commands near the top of root `AGENTS.md`, including the single-test form.
2. **Write the non-obvious; skip what the code already says.** Good entries:
   - gotchas
   - conventions that aren't enforced by tooling
   - "never edit X"
   - "always use wrapper Y"
   - layering rules
   - tenancy and auth scoping

   Don't describe what every file does.
3. **Be concrete and verifiable.** Use real paths in backticks, real class names and real commands. A stale path is the first sign a doc has rotted, so verify each one.
4. **Imperative and short.** "Use `uv run`, never bare `python`." Not paragraphs of rationale. Put the rationale in an ADR and link to it.
5. **No duplication.** Each fact lives in one place:
   - **rules** go in `AGENTS.md`
   - **explanations and diagrams** go in `docs/architecture.md`
   - **the "why"** goes in `docs/adr/`

   Other files link to them.
6. **No secrets, no personal data.** Reference env var *names*, never values.
7. **Mark generated code** as do-not-edit in AGENTS.md *and* enforce it with the PreToolUse hook. Rules alone get ignored under pressure.

## Structure and size

| File | Target size | Notes |
|------|-------------|-------|
| Root `AGENTS.md` | 80–150 lines | Overview, docs map, commands, cross-cutting rules, gotchas, key files |
| Nested `AGENTS.md` | 30–80 lines | Only that area's patterns. Starts with "Supplements the root AGENTS.md" |
| `CLAUDE.md` | 1–10 lines | `@AGENTS.md` import, plus Claude-only notes. Never a copy of AGENTS.md |
| `docs/architecture.md` | 100–250 lines | System context, layers table, **one worked trace**, cross-cutting concerns, "where do I find…" |
| `docs/glossary.md` | Table | Term, meaning, scope, code location |
| Pointer files (Copilot/Cursor) | < 15 lines | Point at AGENTS.md; add nothing tool-specific unless needed |

- **Progressive disclosure:** the root file links to the nested files and docs. The agent loads detail only when it works in that area.
- Use **nested AGENTS.md** for a subtree with its own language, framework, build or conventions. Don't create one per folder.
- Use **tables** for maps and lookups, **mermaid** for the system and layer diagrams, and **numbered steps** for workflows.

## Tooling (.claude/)

- **Permissions:** pre-allow the fast, safe, read-only or test commands the team runs constantly (test, lint, format, type-check, `git status/diff/log`). **Deny** `git push` and reads of huge generated folders that waste context. Never pre-allow destructive commands.
- **Hooks:** must be fast, best-effort and cross-platform. A missing tool must never block the agent, except for the deliberate block (exit 2). Use Node so the hooks run on Windows, macOS and Linux alike.
- **Subagents:**
  - `code-reviewer` enforces `docs/review-checklist.md` and doesn't restate it
  - `test-runner` runs the targeted suite and fixes root causes, never weakening assertions
- **Commands:**
  - `/onboard` is a read-only guided tour, verified against the code
  - `/trace <feature>` follows one feature through every layer

## Multi-agent compatibility

`AGENTS.md` is the shared, tool-neutral source of truth. Other tools get thin pointers:
- Claude Code: `CLAUDE.md` containing `@AGENTS.md`
- GitHub Copilot: `.github/copilot-instructions.md`
- Cursor: `.cursor/rules/agents.mdc` with `alwaysApply: true`

## ADRs

- Write an ADR only for decisions the **user confirmed**. Infer candidates, but never make up history.
- Number them sequentially. `0000-template.md` is the template.
- Each ADR names the files where the decision lives and which AGENTS.md rule enforces it.

## Keeping it alive

- Changing a convention means updating `AGENTS.md` and `architecture.md` in the same PR. Put this rule in the review checklist.
- Re-run `/agent-ready audit` to find stale paths and missing sections.
