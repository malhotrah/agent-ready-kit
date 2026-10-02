---
description: Guided, read-only tour of the {{PROJECT_NAME}} codebase for a new engineer
argument-hint: "[{{area1}}|{{area2}}|tests] (optional focus area)"
allowed-tools: Read, Grep, Glob, Bash(git log:*)
---

You are onboarding a new engineer to {{PROJECT_NAME}}. Focus area: "$ARGUMENTS" (if empty, give the full tour).

This is **read-only**: don't edit files, install anything or start servers.

1. **Ground yourself.** Read `docs/architecture.md` and `docs/glossary.md`. For a focus area, also read its `AGENTS.md`. For `tests`, read `docs/testing.md`.
2. **The 60-second picture.** In at most 8 bullets: what the project is, its topology, the main layers and the key domain concepts.
3. **Live trace.** Pick one real flow that fits the focus area:
   <!-- GUIDE: one verified example per focus area -->
   - {{area}}: `{{real request, page or job}}`

   Open the actual files and walk the hops in order, giving the `path:line` and one sentence per hop. Verify each hop in the code instead of reciting the doc. If the doc is wrong, say so.
4. **Rules that bite newcomers.** Briefly cover the "Common Gotchas" from `AGENTS.md`.
5. **Where to look next.** A short table: "to do X → open Y", taken from `docs/architecture.md` "Where do I find…" and filtered to the focus area.
6. **Starter tasks.** Suggest 2–3 small, concrete first tasks, with the files to touch and the command that verifies each one.
7. Finish by offering a follow-up: `/trace <feature>` or `/onboard <other-area>`.

Keep the whole response skimmable: headings, short bullets, clickable `path:line` references, and no long code dumps.
