# {{PROJECT_NAME}} Development Guide for AI Agents

<!-- GUIDE: Target 80–150 lines. Rules and commands only; explanations live in docs/architecture.md. -->

## Project Overview

{{ONE_PARAGRAPH: what the project is, main stack with versions, persistence, how the pieces are deployed}}

<!-- OPTIONAL: include only when dev and prod topology differ -->
**Development vs Production:**
- **Development:** {{e.g. frontend on :3000 and backend on :9000 as separate processes}}
- **Production:** {{e.g. single container, frontend served statically by the backend}}

<!-- OPTIONAL: include only when nested AGENTS.md files exist -->
**Area-specific rules load from nested files.** Read them before working in that subtree:
- `{{area}}/AGENTS.md`: {{one-line scope}}

## Docs Map

<!-- GUIDE: list only docs that exist after generation. Adjust the docs root if it moved. -->
| Need | Read |
|------|------|
| How the system fits together, request lifecycle | `docs/architecture.md` |
| Day-1 setup and first change | `docs/onboarding.md` |
| Test layout, fixtures, running a single test | `docs/testing.md` |
| Domain vocabulary | `docs/glossary.md` |
| PR review checklist | `docs/review-checklist.md` |
| Why things are the way they are | `docs/adr/` |

## Essential Commands

<!-- GUIDE: exact commands confirmed in interview Round B. Always include the single-test form. -->
**Development:**
```bash
{{SETUP_COMMAND}}        # Install dependencies
{{RUN_COMMAND}}          # Start the app
```

**Testing & quality:**
```bash
{{TEST_COMMAND}}         # Run all tests
{{SINGLE_TEST_COMMAND}}  # Run one test
{{LINT_COMMAND}}         # Lint
{{FORMAT_COMMAND}}       # Format
{{TYPECHECK_COMMAND}}    # Type-check
{{PRE_PR_COMMAND}}       # Full validation before a PR
```

<!-- OPTIONAL --> **Code generation / migrations:**
```bash
{{CODEGEN_COMMAND}}      # Regenerate {{what}} after changing {{source of truth}}
{{MIGRATE_COMMAND}}      # Create a DB migration
```

## Cross-Cutting Concerns

<!-- GUIDE: 3–6 numbered rules that span areas: source-of-truth/codegen, tenancy/auth scoping, wrappers (always `uv run`), pre-commit, etc. Link the ADR where there is one. -->
1. **{{Rule}}:** {{imperative detail, with real paths}}

## Pull Request Basics

<!-- GUIDE: derive from the PR template, CONTRIBUTING.md and commit history (e.g. Conventional Commits). -->
1. {{PR rule}}
2. Review against `docs/review-checklist.md`

## Common Gotchas

<!-- GUIDE: the highest-value section. Use answers from Round C plus what you found. Each bullet is one line. -->
- **Don't manually edit generated files:** `{{generated paths}}`. Run `{{CODEGEN_COMMAND}}` instead.
- {{gotcha}}

## Key Files to Reference

<!-- GUIDE: 5–8 files an agent should open to learn the patterns: base classes, factories, config, test conftest, codegen entry. -->
- `{{path}}`: {{why}}
