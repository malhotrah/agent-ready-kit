# {{AREA_NAME}} ({{AREA_PATH}}/): Agent Rules

Supplements the root `AGENTS.md`. Full picture: `docs/architecture.md#{{anchor}}`.

<!-- GUIDE: 30–80 lines. Only this area's patterns. Name real base classes, factories and folders, all verified. -->

## {{Primary pattern, e.g. "Controller → Service → Repository"}}

- **{{Layer}}** (`{{path glob}}`): {{responsibility}}; inherit from `{{BaseClass}}` (`{{file}}`)

## {{Organisation / naming conventions}}

- {{rule}}

<!-- OPTIONAL -->
## Example

```{{lang}}
{{a short, real idiomatic snippet copied or adapted from the codebase (5–15 lines)}}
```

## Rules

1. {{area-specific rule, e.g. "Type hints mandatory", "No new `any`", "Only edit en-US locale"}}
2. **Verify:** `{{area test command}}` (fast) or `{{area full check}}`
