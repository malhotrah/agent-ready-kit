# Engineering Docs

Internal docs for people (and agents) working **on** {{PROJECT_NAME}}'s code.
<!-- OPTIONAL: if a public docs site lives nearby, say how these differ, e.g. "Don't confuse them with `docs/docs/`, the public site." -->

## Reading order for new engineers

1. {{onboard entry point, e.g. "`/onboard` in Claude Code"}}
2. [onboarding.md](onboarding.md): setup and your first change
3. [architecture.md](architecture.md): system, layers, request trace
4. [glossary.md](glossary.md): domain vocabulary
5. [testing.md](testing.md): test layout, fixtures, commands
6. [review-checklist.md](review-checklist.md): what reviewers look for
7. [adr/](adr/): why the main patterns exist

## Keeping these docs alive

- Change a convention or a layer boundary? Update `architecture.md` and the matching `AGENTS.md` in the same PR.
- Made a non-obvious design decision? Copy [adr/0000-template.md](adr/0000-template.md) to the next number.
- Reference real paths in backticks. Stale paths are the first sign a doc has rotted.
