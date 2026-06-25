---
name: bootstrap-claude-project
description: Bootstrap a Road24 repo's .claude/ setup — detect its stack, generate a CLAUDE.md, and install the right role agents + scaffolding skills from the road24-ai hub. Use to onboard a project that lacks (or has a thin) .claude/ directory.
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[target-repo-path]"
---

# Bootstrap a Project's Claude Setup

Set up `.claude/` for: $ARGUMENTS  (default: the current repo)

Pull from the central hub at `~/work/road24-ai` so the project gets consistent, stack-correct agents
and skills instead of generic ones.

## Steps

1. **Detect the stack** — inspect manifests in the target repo:
   - `pyproject.toml` + FastAPI imports → FastAPI service
   - `manage.py` / Django in deps → Django/DRF
   - `package.json` with `@nestjs/*` → NestJS
   - `package.json` with `react`/`vite`/`next` → React/TS frontend
   - `pubspec.yaml` → Flutter · RN deps + `Gemfile` → React Native
   Cross-check against `road24-ai/knowledge/platform-map.md`.

2. **Read the hub** — `road24-ai/agents/*` and `road24-ai/skills/*` to know what's available.

3. **Generate `.claude/CLAUDE.md`** in the target repo with: project overview, exact stack, the real
   commands (build/test/lint/migrate — read them from the Makefile/package.json/pyproject), the
   architecture/layering, and a short index of the agents + skills installed. Include the **Learning
   Rule** (persist user corrections to CLAUDE.md / concept / agent / skill so they're never repeated).

4. **Install rules** into `.claude/rules/` — copy the path-scoped rule(s) for the repo's stack from
   `road24-ai/rules/` (e.g. `backend-fastapi.md` OR `backend-django.md`, `frontend-react.md`,
   `frontend-svelte.md`, `frontend-vue.md`, `backend-nestjs.md`, `mobile-flutter.md`, plus
   `infra-k8s.md` if it has Docker/CI and `tests.md`). Keep the quoted `paths:` globs. These
   auto-load by file path. Also copy the **`road24-conventions` skill** (with its `references/`) — the
   deep rulebook — so agents preload it.

5. **Install agents** into `.claude/agents/` — copy the relevant role agents from the hub: the
   stack's engineer, `tester`, and the language-matched reviewer (`python-reviewer` /
   `typescript-reviewer` / `javascript-reviewer` / `flutter-reviewer`) always; add `security-auditor`
   for services handling auth/payments/PII, `devops` if it has Docker/CI, an architect/`orchestrator`
   for larger repos. Trim each to the detected stack.

6. **Install skills** into `.claude/skills/` — copy the scaffolding skills that match the stack
   (e.g. FastAPI: `new-fastapi-endpoint`/`-service`/`-repository`/`-pydantic-schema`; Django: the
   `new-django-*` set; Nest: `new-nest-resource`; frontend: `new-react-feature`/`new-vue-feature`/
   `new-svelte-feature`/`new-api-client`; Flutter: `new-flutter-feature`).

7. **Install hooks + settings** — copy `hooks/guard.sh` + `hooks/format.sh` (`chmod +x`, needs `jq`)
   and a `settings.json` wiring them + sane model/permissions; add `settings.local.json.example`.

8. **Report** — what stack was detected, which rules/agents/skills/hooks were installed, and the
   commands wired into CLAUDE.md.

## Rules

- Match what already exists — if the repo has a `.claude/`, extend, don't overwrite.
- The commands in CLAUDE.md must be the **real** ones from the repo, verified against its files.
- Keep agents/rules lean and stack-specific; don't dump every hub file into every project.
- QUOTE rule `paths:` globs. Don't invent files the repo doesn't have.
