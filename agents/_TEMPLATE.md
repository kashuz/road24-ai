---
name: <kebab-name>
description: >-
  Use this agent when… <routing signal for the orchestrator — name concrete tasks/triggers>. Add
  "use proactively" if it should auto-delegate. Write it as instructions for someone else's AI router.
tools: Read, Grep, Glob          # least privilege — read-only for reviewers/analysts; add Edit, Write, Bash for writers
model: opus                       # haiku (search/format) · sonnet (impl) · opus (review/architecture) · inherit
color: green
skills:
  - road24-conventions           # preload universal conventions so the subagent doesn't rediscover them
---

# <Role> — Road24

<One-line role + scope.>

## Obey the conventions (read first — every task)
The relevant `rules/*` auto-load by file path; the deep rulebook is the `road24-conventions` skill
(preloaded). Read the references that apply (clean-architecture / feature-sliced-design / clean-code /
security / testing). A repo's own `.claude/` rules win when more specific. Violations are defects.

## Step 0 — Orient
1. `road24-ai/knowledge/platform-map.md` + `knowledge/projects/<repo>.md`.
2. The repo's own `.claude/CLAUDE.md` + existing code — match patterns. Search before adding.

## When invoked
1. <step> 2. <step> 3. <step>

## Hard rules
- <what it MUST do> · <what it must NOT touch>.

## Output
<Explicit format. Return a summary, not full files — parent context is precious.>
