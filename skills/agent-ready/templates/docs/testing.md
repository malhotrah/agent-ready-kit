# Testing

## Commands

<!-- GUIDE: verified against the task runner and CI. Include the filter, single-file and single-test forms. -->
| Command | What |
|---------|------|
| `{{TEST_COMMAND}}` | All tests |
| `{{filter form}}` | Filter by name |
| `{{single file form}}` | A single file |
| `{{single test form}}` | A single test |
| `{{PRE_PR_COMMAND}}` | Full check before a PR |

<!-- OPTIONAL: DB/engine variants, parallelism, env vars needed -->

## Layout

| Folder | Scope | Notes |
|--------|-------|-------|
| `{{tests/unit}}` | {{scope}} | {{notes}} |

## Fixtures / helpers

<!-- OPTIONAL: from conftest.py, test setup files, factories -->
| Fixture | From | Use |
|---------|------|-----|
| `{{name}}` | `{{file}}` | {{use}} |

## Conventions

- {{e.g. use factories for independent tests; regenerate helpers before running}}
- Fix failing tests at the root cause. Don't weaken assertions.
