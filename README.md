# agent-ready-kit

Make any **existing codebase** ready for coding agents (Claude Code, Copilot, Cursor, …) with one command.

The kit installs a Claude Code skill, `/agent-ready`. Run it inside a repo and it will:

1. **Scan** the code: stack, commands, CI, tests, generated code, architecture and existing agent files.
2. **Interview you** about the areas, commands, team rules, gotchas, and the tooling you want. Its options come pre-filled from what it found.
3. **Show a plan** of the files to create or merge, and wait for your go-ahead.
4. **Write files grounded in your real code.** Every path and command is verified rather than copied from a template.
5. **Ask per file** when something already exists: merge, replace, keep, or write a side-by-side `.proposed` copy. Nothing is overwritten silently.
6. **Validate** the result: JSON parses, hooks are smoke-tested, and every path named in the docs exists.

## Install (one command)

First, clone or copy this folder, then from inside it run one of these.

**Windows (PowerShell)**
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

**macOS / Linux / Git Bash**
```bash
bash install.sh
```

The installer copies `skills/agent-ready` into `~/.claude/skills/agent-ready`, or into `$CLAUDE_CONFIG_DIR/skills` if that's set. Flags:

| Windows | macOS/Linux | Effect |
|---------|-------------|--------|
| `-Force` | `--force` | Replace an existing install without asking |
| `-Uninstall` | `--uninstall` | Remove the skill |

**Manual install:** copy `skills/agent-ready/` to `~/.claude/skills/agent-ready/`.

**Team install, no per-person setup:** copy `skills/agent-ready/` into a repo at `.claude/skills/agent-ready/` and commit it. Everyone who opens that repo in Claude Code gets `/agent-ready`.

### Requirements
- [Claude Code](https://docs.claude.com/en/docs/claude-code): the CLI, the desktop app's Code tab, or the IDE extension.
- Node.js, only if you want the generated hooks. The skill detects whether Node is available and offers to skip the hooks.

## Use

```bash
cd path/to/your-repo
claude
```
Then, inside Claude Code:

| Command | What it does |
|---------|--------------|
| `/agent-ready` | Full run: scan, interview, plan, write, validate |
| `/agent-ready audit` | Read-only. Reports which files are missing or stale (for example, paths in docs that no longer exist) |
| `/agent-ready services/api` | Full run, limited to one subtree (for big monorepos) |

Tip: run it on a clean git branch so you can review everything with `git diff` before committing.

## What it generates

You choose which of these you get during the interview.

| File | Purpose |
|------|---------|
| `AGENTS.md` | Tool-neutral source of truth: overview, docs map, commands, cross-cutting rules, gotchas, key files |
| `<area>/AGENTS.md` | Per-area rules (e.g. `backend/`, `frontend/`, each package), loaded when an agent works there |
| `CLAUDE.md` | A thin `@AGENTS.md` import, so Claude Code loads the same rules |
| `docs/architecture.md` | System diagram, layers, **a worked trace of one real request**, a "where do I find…" table |
| `docs/onboarding.md` | Prerequisites, setup, first change, agent tooling overview |
| `docs/testing.md` | Test commands (including the single-test form), layout, fixtures, conventions |
| `docs/glossary.md` | Domain terms mapped to code |
| `docs/review-checklist.md` | PR checklist derived from your rules (also used by the `code-reviewer` subagent) |
| `docs/adr/` | A template, plus one ADR for each design decision you confirm |
| `.claude/settings.json` | Pre-approved safe commands (test, lint…), with `git push` denied |
| `.claude/hooks/block-generated-edits.js` | Stops agents from editing generated files |
| `.claude/hooks/format-on-edit.js` | Auto-formats each file the agent edits |
| `.claude/agents/code-reviewer.md`, `test-runner.md` | Pre-PR review subagent, and a subagent that runs and fixes tests |
| `.claude/commands/onboard.md`, `trace.md` | `/onboard [area]` guided tour; `/trace <feature>` through every layer |
| `.github/copilot-instructions.md` | Copilot pointer to AGENTS.md |
| `.cursor/rules/agents.mdc` | Cursor pointer to AGENTS.md |

The best practices the skill follows are in [skills/agent-ready/references/best-practices.md](skills/agent-ready/references/best-practices.md). They include size limits, "commands first", no duplication across files, verified paths only, and no secrets.

## Worked example

`C:\AI\Flo\samplerepo-agentready` (the Mealie repo) is the reference end state these templates were modelled on. Compare its `AGENTS.md`, `docs/` and `.claude/` with your output.

## Customising the kit

- **Templates:** `skills/agent-ready/templates/`. `{{PLACEHOLDERS}}` are filled from your code and answers. `<!-- GUIDE: -->` comments are instructions to the agent and are stripped from the output.
- **Rules:** edit `references/best-practices.md` to change house style, for example line limits or required sections.
- **New file types:** add a template and a row in `references/file-catalog.md`.
- After editing, re-run the installer with `-Force` / `--force`.

## FAQ

**Does it change my code?** No. It only writes the docs and config files above, and it asks before touching any file that already exists.

**Does it commit or push?** No. You review and commit the changes yourself.

**Will it run my build or tests?** Only at the end, only the test command you confirmed, and only if you agree.

**The output looks generic.** Re-run `/agent-ready` and give fuller answers to the "Rules and gotchas" questions. That section is where most of the value comes from.

**Keeping docs fresh?** Run `/agent-ready audit` every so often, or after big refactors.
