# Onboarding: your first day on {{PROJECT_NAME}}

Goal: by the end of today you'll have the app running locally, understand how a request flows through it, and have one small change working with tests passing.

## 1. Prerequisites

<!-- GUIDE: from manifests, version files (.nvmrc, .python-version, rust-toolchain), the devcontainer and CI setup steps. -->
| Tool | Why | Check |
|------|-----|-------|
| {{tool}} | {{why}} | `{{tool --version}}` |

<!-- OPTIONAL --> **Shortcut:** open the repo in the **Dev Container** (`.devcontainer/`).

## 2. Install and run

```bash
{{SETUP_COMMAND}}
{{RUN_COMMAND}}     # -> {{url}}
```

## 3. Read (in this order)

1. [architecture.md](architecture.md), especially the "Worked trace"
2. [glossary.md](glossary.md)
3. Root `AGENTS.md`{{ plus nested AGENTS.md files}}
4. [testing.md](testing.md)
5. Skim [adr/](adr/)

## 4. Make a first change

<!-- GUIDE: concrete steps for the most common change in this repo. Include codegen and migration steps where they apply. -->
1. Find the closest existing example (`/trace <feature>` in Claude Code).
2. {{step}}
3. Add or extend a test and run `{{SINGLE_TEST_COMMAND}}`.
4. Before pushing, run `{{PRE_PR_COMMAND}}`.
5. Open a PR and self-review against [review-checklist.md](review-checklist.md).

## 5. Agent tooling in this repo

<!-- GUIDE: list only what was generated. -->
| Thing | Where | What it does |
|-------|-------|--------------|
| `AGENTS.md` (root{{ and nested}}) | `/`{{, area paths}} | Rules loaded automatically (Claude via `CLAUDE.md` → `@AGENTS.md`) |
| `/onboard`, `/trace` | `.claude/commands/` | Guided tour, feature tracing |
| `code-reviewer`, `test-runner` | `.claude/agents/` | Pre-PR review, test-fix loop |
| Hooks | `.claude/hooks/` | {{what each does}} |
| Permissions | `.claude/settings.json` | Pre-approves safe commands; denies `git push` |

## 6. Getting help

- {{links: CONTRIBUTING.md, chat channel, maintainers file}}
