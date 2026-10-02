---
description: Trace a feature or endpoint through every layer of {{PROJECT_NAME}}
argument-hint: <endpoint path or feature name>
allowed-tools: Read, Grep, Glob
---

Trace "$ARGUMENTS" through the {{PROJECT_NAME}} stack. This is read-only.

Use `docs/architecture.md` "Worked trace" as the model for the output. Find each hop by searching the code, not by guessing:

<!-- GUIDE: one step per real layer, in request order, with glob hints and the base classes to look for. -->
1. **{{Layer}}.** Find {{what}} in `{{path glob}}`. Note {{auth / scoping / base class implications}}.
N. **Tests.** Find the tests covering it (`{{test glob}}`). If coverage is missing, say so.

Output:
- a compact table: `Layer | File:line | Symbol | Note`
- a 3–5 line narrative of the flow
- a "Gotchas" section covering anything surprising, such as logic in the wrong layer, missing scoping, missing tests or generated code involved

If the feature doesn't exist or is ambiguous, list the closest matches and stop.
