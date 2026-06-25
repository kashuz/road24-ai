# CLAUDE.md — road24-ai hub

Guidance for Claude Code when working in `road24-ai`, the central second brain for the Road24 suite.

## What this repo is

The reusable layer for the whole Road24 Claude Code suite: **role-grouped agents** (`agents/`),
**cross-stack skills** (`skills/`), and the **platform knowledge** (`knowledge/`). Per-repo `.claude/`
dirs under `~/work` hold project-local config; this hub holds what's shared.

## Always read first

- `knowledge/platform-map.md` — the map of every service, its stack, architecture, and the shared
  conventions/contracts.
- The **`road24-conventions` skill** — the binding architecture rulebook (clean-architecture,
  feature-sliced-design, clean-code, security, testing) in its `references/`, preloaded into the
  engineering agents. Per-language reviewers + `security-auditor` enforce it; a repo's own `.claude/`
  rules win when more specific.

## Mental model (where things go)

- **CLAUDE.md** — what's ALWAYS true; lean (loaded every session).
- **rules/** — per-AREA conventions, auto-loaded by file path (e.g. `*.py` → backend rules).
- **skills/** — multi-step WORKFLOWS with templates/scripts (+ `road24-conventions` = universal rulebook).
- **agents/** — isolated subagent personas for scoped jobs.
- **hooks/** — deterministic shell enforcement (`guard.sh` pre-bash, `format.sh` post-edit).
- **settings.json** — model, permissions (allow/deny), hook wiring.

Rule of thumb: **conventions → rules, workflows → skills, always-true → CLAUDE.md, isolated jobs → agents.**

## Design principles (keep these when editing the hub)

- **Engineers = per language/stack.** One implementer per stack (fastapi, django, nestjs, react,
  svelte, vue, flutter, react-native), each scoped to the Road24 repos it covers. Per-project
  specifics live in `knowledge/projects/*`, not duplicated into every agent. Don't create one agent
  per repo (25+) — group by stack and lean on the knowledge base.
- **Architects = split** into `backend-architect` + `frontend-architect`.
- **Reviewers = per language:** `python-reviewer`, `typescript-reviewer`, `javascript-reviewer`,
  `flutter-reviewer` (route each file to its language's reviewer).
- **Other cross-cutting roles = single, stack-aware agents:** `tester`, `security-auditor`, `devops`,
  `orchestrator`.
- **Skills = stack-specific recipes.** Scaffolding differs too much per framework to merge, so each
  stack gets its own `new-*` skill. Plus cross-cutting workflow skills.
- **Rules = per-area conventions, path-auto-loaded.** `rules/*.md` carry quoted `paths:` and load when
  a matching file is read/edited. Per-area coding convention → a rule. The deep cross-cutting rulebook
  lives in the `road24-conventions` skill `references/` (it also reaches subagents via their `skills:`).
  Don't duplicate a convention in both — link.
- **Hooks + settings = deterministic enforcement.** `hooks/guard.sh` (block dangerous bash) and
  `format.sh` (format on edit) wired in `settings.json`; `settings.local.json` for personal overrides.
- **Single source of truth.** Conventions live in `platform-map.md` and each repo's `.claude/`.
  Agents/skills **link** to them — don't duplicate the detail, or it drifts.
- **Real commands only.** Any command an agent/skill cites must be the actual one from the target
  repo (Makefile / package.json / pyproject), verified — not assumed.

## Conventions for files here

- **Agent** front-matter: `name`, `description` (with trigger phrases), `tools` (least privilege),
  `model`, `color`, `skills:` (preload `road24-conventions`). Body: "Step 0 — Orient" → stack playbooks
  → rules → explicit output. Copy `agents/_TEMPLATE.md`.
- **Skill** front-matter: `name`, `description`, `user-invocable: true`, `allowed-tools`,
  `argument-hint`. Body: steps → templates → rules; `$ARGUMENTS` for input. Copy `skills/_TEMPLATE/`.
- **Rule** front-matter: quoted `paths:` globs + one-line `description`. Body: imperative bullets with
  reasons; link to the rulebook references, don't restate. Copy `rules/_TEMPLATE.md`.

## rules/ gotchas (current Claude Code behaviour)

- QUOTE every glob — YAML reserves `*`/`{`; unquoted patterns silently fail.
- Path rules load on READ/EDIT, not CREATE — keep creation-critical rules in CLAUDE.md or unscoped.
- Rules are per-repo when installed. In this hub they're a **library**; `bootstrap-claude-project`
  installs the right ones per repo (so `backend-fastapi` and `backend-django` can coexist here even
  though both match `**/*.py`). Verify a rule loads with `/memory` while editing a matching file.

## Learning rule

When the user corrects an approach or convention, persist it immediately so it's never repeated:
- a **per-area coding convention** → the right `rules/*.md`
- a **cross-cutting architecture principle** → `skills/road24-conventions/references/*.md`
- a **suite-wide** fact → `knowledge/platform-map.md`
- an **agent's** workflow → that `agents/*.md`
- a **skill's** template → that `skills/*/SKILL.md`
- a **project-local** rule → that repo's own `.claude/` (not here)

## Maintenance

When a repo's stack/role changes, or a new repo is added under `~/work`, update the table in
`knowledge/platform-map.md` first — the agents key off it.
