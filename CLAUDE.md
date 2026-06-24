# CLAUDE.md — road24-ai hub

Guidance for Claude Code when working in `road24-ai`, the central second brain for the Road24 suite.

## What this repo is

The reusable layer for the whole Road24 Claude Code suite: **role-grouped agents** (`agents/`),
**cross-stack skills** (`skills/`), and the **platform knowledge** (`knowledge/`). Per-repo `.claude/`
dirs under `~/work` hold project-local config; this hub holds what's shared.

## Always read first

- `knowledge/platform-map.md` — the map of every service, its stack, architecture, and the shared
  conventions/contracts.
- `concepts/` — the **binding architecture rulebook** (clean-architecture, feature-sliced-design,
  clean-code, security, testing). Every agent obeys the concepts relevant to its work; `reviewer` and
  `security-auditor` enforce them. A repo's own `.claude/concepts/*` win when more specific.

## Design principles (keep these when editing the hub)

- **Engineers = per language/stack.** One implementer per stack (fastapi, django, nestjs, react,
  svelte, vue, flutter, react-native), each scoped to the Road24 repos it covers. Per-project
  specifics live in `knowledge/projects/*`, not duplicated into every agent. Don't create one agent
  per repo (25+) — group by stack and lean on the knowledge base.
- **Architects = split** into `backend-architect` + `frontend-architect`.
- **Cross-cutting roles = single, stack-aware agents:** `tester`, `reviewer`, `security-auditor`,
  `devops`, `orchestrator`.
- **Skills = stack-specific recipes.** Scaffolding differs too much per framework to merge, so each
  stack gets its own `new-*` skill. Plus cross-cutting workflow skills.
- **Concepts = the binding rulebook.** Stack-agnostic principles in `concepts/`. Agents reference and
  obey them; skills encode them in their templates/rules. Keep concepts DRY — state a rule once here,
  link to it from agents/skills rather than restating it.
- **Single source of truth.** Conventions live in `platform-map.md` and each repo's `.claude/`.
  Agents/skills **link** to them — don't duplicate the detail, or it drifts.
- **Real commands only.** Any command an agent/skill cites must be the actual one from the target
  repo (Makefile / package.json / pyproject), verified — not assumed.

## Conventions for files here

- **Agent** front-matter: `name`, `description` (with trigger phrases), `tools`, `model`, `color`.
  Body: a "Step 0 — Orient" that reads the platform map + repo CLAUDE.md, then stack playbooks + rules.
- **Skill** front-matter: `name`, `description`, `user-invocable: true`, `allowed-tools`,
  `argument-hint`. Body: steps → templates → rules. Use `$ARGUMENTS` for the invocation input.

## Learning rule

When the user corrects an approach or convention, persist it immediately so it's never repeated:
- a **suite-wide architecture rule** → the right `concepts/*.md`
- a **suite-wide** fact → `knowledge/platform-map.md`
- an **agent's** workflow → that `agents/*.md`
- a **skill's** template → that `skills/*/SKILL.md`
- a **project-local** rule → that repo's own `.claude/` (not here)

## Maintenance

When a repo's stack/role changes, or a new repo is added under `~/work`, update the table in
`knowledge/platform-map.md` first — the agents key off it.
