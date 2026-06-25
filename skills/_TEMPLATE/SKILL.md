---
name: <kebab-name>
description: >-
  What it does AND when to use it — name concrete tasks, filetypes, and trigger phrases. Be slightly
  pushy to fight under-triggering ("use whenever the user touches X, even if they don't mention Y").
  Keep tight — descriptions share a context budget.
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob   # add Bash only if the workflow runs commands
argument-hint: "[arg1] [arg2]"
---

# <Skill name>

Do: $ARGUMENTS

## Steps
1. **Read first** — <existing patterns to match>.
2. <imperative step> → <step> → <step>.
3. Run lint/tests; don't report done until green.

## Template
```<lang>
<the canonical snippet to produce>
```

## Rules
- <hard rule> — <why>.
- Follow `road24-conventions`; the area `rules/*` auto-load. Repo-local `.claude/` wins when more specific.

<!-- Keep < 500 lines. Push deep detail to references/, deterministic work to scripts/. -->
