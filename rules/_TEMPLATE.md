---
# Per-area convention rule. Auto-loads when Claude reads/edits a matching file.
# QUOTE every glob — YAML reserves * and { ; unquoted patterns silently fail.
paths:
  - "**/*.ext"
  - "src/area/**"
description: One line — what area this governs (shown in /memory).
---

# <Area> conventions

Imperative bullets. State the rule AND the reason — models follow reasons more reliably than "MUST".
Keep it short (this loads every time a matching file is touched). Push deep detail to the
`road24-conventions` skill references; link, don't restate.

## Architecture
- <layering / structure rule> — <why>.

## Style
- <language/style rule> — <why>.

## Security
- <area-specific security rule> — <why>.

## Tests
- <what/how to test in this area> — <why>.

> Deep rulebook: `skills/road24-conventions/references/*`. Repo-local `.claude/` rules win when more specific.
