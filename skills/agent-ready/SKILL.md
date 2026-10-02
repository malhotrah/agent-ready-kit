---
name: agent-ready
description: Make an existing codebase ready for coding agents. Scans the repo, interviews the user, then writes grounded AGENTS.md (root + nested), CLAUDE.md, engineering docs (architecture, onboarding, testing, glossary, review checklist, ADRs), .claude tooling (settings, hooks, subagents, commands) and pointers for Copilot/Cursor. Use when the user says "make this repo agent-ready", "set up AGENTS.md / CLAUDE.md", "add agent best practices", or runs /agent-ready.
argument-hint: "[optional: subfolder to focus on, or 'audit' to only report gaps]"
---

# /agent-ready

You are making the **current repository** ready for coding agents. The output must be **grounded in this repo's real code**. A generic template the user could have downloaded is a failure.

Arguments: `$ARGUMENTS`
- empty: full run
- `audit`: do Phase 1 only, then report what exists, what is missing and what is stale. Write nothing.
- a path: limit nested AGENTS.md and area docs to that subtree

Before starting, read `references/best-practices.md` and `references/file-catalog.md` in this skill's folder. Templates live in `templates/`. Each template's `<!-- … -->` comments are instructions to you. **Remove all of them, and every `{{placeholder}}`, from the output.**

## Hard rules

- **Never overwrite or delete an existing file silently.** See Phase 5.
- **Never invent facts.** Every path, command, class or function you name must be verified with Glob, Grep or Read. If you can't verify something, leave it out or ask.
- **Never write secrets** (tokens, passwords, internal URLs the user hasn't approved) into any file.
- **Don't run** installs, builds, migrations, servers or anything that mutates state. The exception is Phase 6 validation, and you must ask before running the repo's own test or lint commands.
- Don't commit, push or create branches unless the user asks.

---

## Phase 1: Detect (read-only)

Build a findings summary. Use Glob, Grep and Read, and run several in parallel. Look for:

1. **Stack and manifests:**
   - `package.json` (and workspaces), `pnpm-workspace.yaml`
   - `pyproject.toml`, `requirements*.txt`
   - `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle*`, `*.csproj`/`*.sln`
   - `Gemfile`, `composer.json`, `mix.exs`
   - Note language versions.
2. **Commands:**
   - task runners: `Taskfile.yml`, `Makefile`, `justfile`, `package.json` scripts, `tox.ini`/`noxfile.py`
   - scripts in `scripts/` / `bin/`
   - `.github/workflows/*`, `.gitlab-ci.yml`, `azure-pipelines.yml`. CI shows what *actually* gets run.
3. **Quality tooling:**
   - linters/formatters: ruff, black, eslint, prettier, biome, golangci, rustfmt, …
   - type checkers
   - pre-commit config
   - test frameworks and test folders
4. **Structure:**
   - the top-level dirs and their purpose
   - candidate **areas** for nested AGENTS.md: separately-built apps, packages in a monorepo, backend/frontend splits, folders with their own manifest
5. **Generated or vendored code:** look for:
   - "generated"/"do not edit" headers (`Grep -i "do not edit|auto-generated|@generated"`)
   - codegen scripts
   - `openapi`/`proto` outputs
   - `vendor/`, `dist/`, `build/`
   - lockfiles
6. **Architecture signals:**
   - entry points (main/app/server files)
   - routing
   - DB/ORM and migrations
   - DI patterns
   - layering (controllers/services/repos, …)
   - multi-tenancy or auth scoping
   - background jobs
   - external integrations
7. **Existing agent and doc files:**
   - `AGENTS.md`, `CLAUDE.md` (any depth)
   - `.claude/**`, `.mcp.json`
   - `.cursor/rules/**`, `.cursorrules`
   - `.github/copilot-instructions.md`, `.github/instructions/**`
   - `.windsurfrules`, `GEMINI.md`
   - `CONTRIBUTING.md`, `docs/**`, ADR folders
   - the PR template
8. **Environment:**
   - Is `node` on PATH? Hooks are written in Node. Run `node -v`.
   - OS (affects hook commands)
   - Is there a dev container?
9. **Recent focus:** `git log --oneline -30` and `git log --format='%an' | sort | uniq -c | sort -rn | head` (team size).

Show the user a **compact findings summary** of no more than about 25 lines: stack, commands found, candidate areas, generated paths, and the existing agent files, each marked *exists / missing / looks stale*.

If `$ARGUMENTS` is `audit`, also list concrete gaps and stale references (paths in existing docs that no longer exist), then stop.

## Phase 2: Interview

Use **AskUserQuestion**. Pre-fill the options from Phase 1 so the user mostly confirms. Mark your recommendation with "(Recommended)". Run these rounds, using up to 4 questions per call. Skip any question already answered unambiguously by the repo.

**Round A: Areas and stack**
- Confirm the detected stack and the one-line project description. Offer your draft, and let them correct it via "Other".
- Which areas get a nested `AGENTS.md`? Use multiSelect over the candidate folders.
- Who is the audience: solo, small team, or open source with outside contributors? This sets the tone and the review checklist depth.

**Round B: Commands**
- Confirm the setup / run / test / single-test / lint / format / type-check / codegen / migrate commands (show the detected ones).
- Is there a preferred wrapper agents must always use, for example "always `uv run`" or "always `task …`, never raw tools"?
- What's the full pre-PR check command?

**Round C: Rules and gotchas**
- Which paths must agents **never edit**? Offer the detected generated/vendored paths, multiSelect.
- Which conventions do agents (or new hires) get wrong most often? Free text via "Other", plus your detected candidates.
- Are there areas that are off limits or need extra care (auth, billing, migrations, translations, infra)?
- Which key design decisions deserve an ADR? Offer 2–4 inferred decisions. Only confirmed ones become ADRs.

**Round D: Tooling choices**
- Which engineering docs to generate: architecture, onboarding, testing, glossary, review checklist, ADRs. Default is all.
- Which `.claude/` items to generate, multiSelect:
  - permissions in `settings.json`
  - hook: block edits to generated files
  - hook: format-on-edit
  - subagent: code-reviewer
  - subagent: test-runner
  - command: /onboard
  - command: /trace
- Which other agents to support: Copilot (`.github/copilot-instructions.md`), Cursor (`.cursor/rules/`), others. Default: point all of them at AGENTS.md.

If `node` is missing, say the hooks need Node and ask whether to skip them or generate them anyway.

## Phase 3: Plan

Present a table: `File | Action (create / merge / skip) | Purpose (one line)`.

Remember:
- Any file that already exists is **merge**, never "create".
- Root `AGENTS.md` comes first, and `CLAUDE.md` should be a thin `@AGENTS.md` import.

Ask for a go-ahead with AskUserQuestion: Proceed / Adjust list / Cancel.

## Phase 4: Generate

Work in this order, so later files can link to earlier ones:

1. `docs/architecture.md` and `docs/glossary.md`. These hold the most research, and everything else links to them.
2. Root `AGENTS.md`, then each nested `AGENTS.md`.
3. `CLAUDE.md` (root, and nested only if the user wants Claude-specific notes there).
4. `docs/onboarding.md`, `docs/testing.md`, `docs/review-checklist.md`, `docs/README.md`, `docs/adr/0000-template.md` plus one ADR per confirmed decision.
5. `.claude/settings.json`, `.claude/hooks/*`, `.claude/agents/*`, `.claude/commands/*`.
6. Other-agent pointer files.

For each file:
- Start from the matching template in `templates/` and follow its inline guidance.
- **Read the real code** for each section. For architecture, trace **one real request or flow end to end**, with real file paths, as the "worked trace".
- Put real commands in, exactly as confirmed in Round B.
- Keep the size limits in `references/best-practices.md`.
- If the engineering docs folder would collide with an existing public docs site (e.g. `docs/` is MkDocs/Docusaurus content), ask where the engineering docs should go: `docs/` top level outside the site root, or `docs/engineering/`.

## Phase 5: Existing files (diff and ask, per file)

For every target path that already exists:
1. Read it fully.
2. Build a **merged** version: keep everything still correct and user-written; add the missing sections; fix stale paths and commands you verified are wrong; don't reorder needlessly.
3. Show a concise unified-style diff (only the changed hunks), plus a one-line summary of why.
4. Ask with AskUserQuestion: **Apply merge** / **Replace with new version** / **Keep existing (skip)** / **Write side-by-side as `<name>.proposed.<ext>`**.
5. Do only what was chosen.

For `.claude/settings.json`, merge JSON keys: union the permission arrays, and append hooks without duplicating them. Never drop the user's existing entries.

## Phase 6: Validate and report

1. Parse every JSON file you wrote: `node -e "JSON.parse(require('fs').readFileSync(process.argv[1],'utf8'))" <file>`.
2. Smoke-test each hook:
   - **block-generated-edits:** pipe `{"tool_input":{"file_path":"<a protected path>"}}` and expect exit code 2. Pipe a normal source path and expect 0.
   - **format-on-edit:** pipe a path with an unrelated extension and expect 0.
3. Re-verify every backticked path in the generated markdown with Glob, and fix or remove any that don't exist.
4. Optionally (ask first), run the confirmed fast test command once to prove the documented command works.
5. Final report:
   - files written / merged / skipped
   - anything left for a human (review the ADRs, fill the glossary terms you couldn't infer)
   - suggested next step: review the diff and commit, e.g. `docs: make repo agent-ready`
   - tip: re-run `/agent-ready audit` periodically to catch doc rot
