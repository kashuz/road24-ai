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

4. **Install concepts** into `.claude/concepts/` — copy the binding rulebook the repo needs from
   `road24-ai/concepts/` (backends: clean-architecture, clean-code, security, testing; frontends:
   feature-sliced-design, clean-code, security, testing). Trim each to the repo's stack. Reference
   them from the generated CLAUDE.md and ensure the installed agents point to them.

5. **Install agents** into `.claude/agents/` — copy the relevant role agents from the hub
   (`engineer`, `tester`, `reviewer` always; add `security-auditor` for services handling
   auth/payments/PII, `devops` if it has Docker/CI, `architect`/`orchestrator` for larger repos).
   Trim each to the detected stack so it's not carrying playbooks for stacks the repo doesn't use.

6. **Install skills** into `.claude/skills/` — copy the scaffolding skills that match the stack
   (e.g. FastAPI: `new-fastapi-endpoint`/`-service`/`-repository`/`-pydantic-schema`; Django: the
   `new-django-*` set; Nest: `new-nest-resource`; frontend: `new-react-feature`/`new-api-client`;
   Flutter: `new-flutter-feature`).

7. **Report** — what stack was detected, which concepts/agents/skills were installed, and the commands
   wired into CLAUDE.md.

## Rules

- Match what already exists — if the repo has a `.claude/` with conventions, extend, don't overwrite.
- The commands in CLAUDE.md must be the **real** ones from the repo, verified against its files.
- Keep agents lean and stack-specific; don't dump every hub agent into every project.
- Don't invent files the repo doesn't have (e.g. don't reference `concepts/*` unless you create them).
