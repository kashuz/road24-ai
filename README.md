# road24-ai

The central "second brain" for the Road24 Claude Code suite — reusable, **role-grouped** agents,
cross-stack **skills**, and the shared **knowledge** map of the platform. Per-repo `.claude/` dirs
hold project-local config; this hub holds what's reusable across every repo under `~/work`.

## Layout

```
road24-ai/
├── agents/                  # per-stack engineers + split architects + cross-cutting roles
│   ├── orchestrator.md          # plan → delegate → integrate → verify (multi-step / cross-repo)
│   ├── backend-architect.md     # service boundaries, contracts, data, migrations, messaging
│   ├── frontend-architect.md    # client module structure, state/data strategy, consistency
│   ├── python-fastapi-engineer.md  # insurance, gateway, bff, localization, tinting, sdk
│   ├── django-engineer.md          # road24-backend
│   ├── nestjs-engineer.md          # nest-insurances
│   ├── react-engineer.md           # dashboard, alimony, portofolio, webviews, fortune
│   ├── svelte-engineer.md          # road24-web (SvelteKit)
│   ├── vue-engineer.md             # new-webview (Vue 3)
│   ├── flutter-engineer.md         # road24-mobile
│   ├── react-native-engineer.md    # R24NativeInsurance
│   ├── tester.md                # unit / integration / endpoint tests across stacks
│   ├── python-reviewer.md          # read-only review of .py (FastAPI, Django/DRF)
│   ├── typescript-reviewer.md      # read-only review of .ts/.tsx (React, Nest, RN, Svelte/Vue TS)
│   ├── javascript-reviewer.md      # read-only review of plain .js (SvelteKit server, Gatsby, Vue)
│   ├── flutter-reviewer.md         # read-only review of .dart (BLoC, freezed, dio)
│   ├── security-auditor.md      # white-box appsec audit (auth, payments, insurance, PII)
│   └── devops.md                # Docker, CI/CD, k8s/manifests, releases
├── rules/                   # per-area conventions, AUTO-LOADED by file path (quoted globs)
│   ├── _TEMPLATE.md
│   ├── frontend-react.md       # "**/*.tsx" — React/RN/TS clients
│   ├── frontend-svelte.md      # "**/*.svelte" — road24-web
│   ├── frontend-vue.md         # "**/*.vue" — new-webview
│   ├── backend-fastapi.md      # "**/*.py" — FastAPI services
│   ├── backend-django.md       # "**/*.py" — road24-backend
│   ├── backend-nestjs.md       # "**/*.ts" — nest-insurances
│   ├── mobile-flutter.md       # "**/*.dart" — road24-mobile
│   ├── infra-k8s.md            # Dockerfile/compose/k8s/helm/tf
│   └── tests.md                # test files (pytest/jest/vitest/flutter_test)
├── skills/                  # user-invocable recipes (33) — see "Skills by category" below
│   └── road24-conventions/  #   the binding rulebook (references/) — preloaded into agents
├── knowledge/
│   ├── platform-map.md      # the ecosystem: services, stacks, conventions, contracts
│   └── projects/            # per-project deep-dives (one file per repo) + index
├── hooks/                   # guard.sh (PreToolUse: block dangerous bash) · format.sh (PostToolUse)
├── settings.json            # model, permissions (allow/deny), hook wiring
├── settings.local.json.example  # personal overrides → copy to settings.local.json (gitignored)
└── CLAUDE.md                # lean constitution + mental model + learning rule
```

## How it's organized

**Engineers are per language/stack.** One implementer per stack (FastAPI, Django, NestJS, React,
Svelte, Vue, Flutter, RN) — each knows its frameworks and the specific Road24 repos it covers, and
reads `knowledge/projects/*` for per-project specifics. (Same-stack projects share conventions, so
this scales better than one agent per repo while keeping per-project detail in the knowledge base.)

**Architects are split** into `backend-architect` and `frontend-architect`.

**Cross-cutting roles** stay single, stack-aware agents: `tester`, `security-auditor`, `devops`, and
the `orchestrator`. **Reviewers are per language** — `python-reviewer`, `typescript-reviewer`,
`javascript-reviewer`, `flutter-reviewer` — so a mixed diff routes each file to the reviewer fluent in
its language.

**Conventions live in two complementary places.** `rules/*` are short per-area coding conventions that
**auto-load by file path** (edit a `.py` → the backend rule loads). The deep, cross-cutting rulebook
(Clean Architecture, Feature-Sliced Design, Clean Code/SOLID, Security, Testing) lives in the
**`road24-conventions` skill** `references/` — preloaded into the engineering agents so subagents get
it too. Both are binding: per-language reviewers + `security-auditor` enforce them; a violation is a
finding, not a style nit. A repo's own `.claude/` rules win when more specific.

**Deterministic enforcement.** `hooks/guard.sh` blocks dangerous Bash (PreToolUse) and `format.sh`
formats edited files (PostToolUse), wired in `settings.json` (needs `jq`).

**Skills are stack-specific recipes** — scaffolding differs too much per stack to merge, so each layer
of each stack gets its own `new-*` skill, plus cross-cutting workflow skills. See the full list below.

## Skills by category (33)

**FastAPI services** (insurance, gateway, bff, localization, tinting, sdk)
`new-fastapi-endpoint` · `new-fastapi-service` · `new-fastapi-repository` · `new-pydantic-schema` ·
`new-rabbitmq-consumer` · `new-celery-task` · `new-alembic-migration` · `wire-sdk-observability`

**Django** (road24-backend)
`new-drf-endpoint` · `new-django-model` · `new-django-dto` · `new-django-repository` ·
`new-django-service` (+ `new-celery-task`)

**NestJS** (nest-insurances)
`new-nest-resource` · `new-nest-test`

**Frontend** (React/Svelte/Vue/RN clients)
`new-react-feature` · `new-react-hook` · `new-vue-feature` · `new-svelte-feature` · `new-api-client` ·
`new-frontend-test`

**Flutter** (road24-mobile)
`new-flutter-feature` · `new-flutter-test`

**Testing** (cross-stack)
`new-pytest-suite` · `new-nest-test` · `new-frontend-test` · `new-flutter-test`

**Ops / DevOps**
`dockerize-service` · `new-ci-pipeline` · `new-k8s-manifest`

**Workflow / cross-cutting**
`road24-conventions` (the universal rulebook, preloaded into agents) · `cross-service-contract` ·
`commit-and-pr` · `security-audit` · `bootstrap-claude-project`

## Using it

- **Invoke an agent** from any repo when you need a specialist: the agent reads the platform map,
  identifies the stack, and follows that repo's conventions.
- **Invoke a skill** (`/new-fastapi-endpoint`, `/new-react-feature`, …) to scaffold to-spec.
- **Onboard a new/thin repo** with `/bootstrap-claude-project` — detects the stack and installs the
  right agents + skills into that repo's `.claude/`.
- **Keep `knowledge/platform-map.md` current** — it's the source of truth every agent reads first.

## The suite (see `knowledge/platform-map.md` for the full map)

FastAPI services (`road24-insurance`, `-gateway`, `-bff`, `-localization`, `-tinting`) · Django/DRF
core (`road24-backend`) · NestJS (`nest-insurances`) · shared `road24-sdk` · React/TS frontends
(`-dashboard`, `-web`, webviews, `-landing`, `tgbot-admin`) · Flutter (`road24-mobile`) · React
Native (`R24NativeInsurance`) · Telegram bots (`tgbot`) · k8s `manifests`.
