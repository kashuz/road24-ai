# Road24 Platform Map

The shared "second brain" map of everything under `~/work`. Agents read this first to know which
stack and conventions apply before touching a repo. Per-project deep-dives live in
`knowledge/projects/<name>.md`. Keep both current — when a repo's stack or role changes, update here.

## Domain

Road24 is a vehicle-management platform for Uzbekistan: vehicle registration, payments, fines,
**OSAGO** (mandatory vehicle insurance), tinting permits, alimony, notifications, lotto, and
government-service integrations (OneID SSO, databanks). It's a polyglot set of microservices +
multiple web/mobile clients. GitHub org: **kashuz**. Branch convention: `RDFT-<n>/...`, `SUG-<n>/...`.

## Road24 services (backend)

| Repo | Role | Stack | Architecture |
|------|------|-------|--------------|
| `road24-backend` | Core monolith — vehicles, payments, fines, lotto, notifications, OneID, telegram | Django 4.2 + DRF, Py 3.10, PostgreSQL/PostGIS, Redis, Celery | Legacy → clean: View → Serializer → DTO → Service → Repository. ~20 apps |
| `road24-insurance` | OSAGO insurance microservice | FastAPI, Py 3.12, async SQLAlchemy, Pydantic v2, PostgreSQL, Redis, **RabbitMQ** (consumers/publisher), Celery, Alembic, uv | Router → Service → Repository |
| `road24-gateway` | Thin API gateway (routes only) | FastAPI, Py 3.12, httpx async, JWT | Router → Service(http) — minimal |
| `road24-bff` | Backend-for-frontend (aggregates services) | FastAPI, Py 3.12, httpx async, Redis, Celery, JWT | Router → Service → Repository(http) |
| `road24-localization` | i18n/translations + external-service mocks | FastAPI, Py 3.12, SQLAlchemy, Alembic | Router → Service → Repository |
| `road24-tinting` | Tinting-permit service (early stage) | FastAPI, Py 3.12 | `src/api` + main.py |
| `road24-sdk` | Shared logging/metrics SDK | Py 3.12, dataclasses (slots), StrEnum, prometheus_client, ContextVar | Sentry-style `init()` + integrations: fastapi, faststream, httpx, redis, sqlalchemy |
| `nest-insurances` | Universal insurance-services gateway | NestJS, TypeORM, class-validator, Swagger, Redis cache, microservices | Controller → Service → Repository + DTOs |

## Road24 clients (web/mobile)

| Repo | Role | Stack |
|------|------|-------|
| `road24-dashboard` | Internal admin dashboard | React + TS, **MUI**, **Redux Toolkit**, React Query, react-intl, Formik, Vite, vitest |
| `road24-web` | Main web app | **SvelteKit** + TS, Sentry, axios, knex/pg (server), prom-client, pdf-lib |
| `road24-insurance-webview` (`road24-webviews`) | Insurance micro-frontends | **pnpm monorepo** (`apps/host`, `apps/scoring-validator`), MFE, Vite |
| `road24-landing` | Marketing landing | **Gatsby** (React) |
| `new-webview` | Insurance webview | **Vue 3** + Vite |
| `road24_alimony_web` | Alimony web app | React + TS, Vite, i18next, react-router, zod |
| `portofolio` | Company portfolio site | React + TS, Vite, Redux Toolkit, i18next |
| `fortune` / `fortuneplanet` | Fortune/marketing sites | **Next.js** + TS |
| `road24-mobile` | Mobile app | Flutter 3, flutter_bloc, dio, freezed, firebase |
| `R24NativeInsurance` | Native insurance client | React Native + TS, React Navigation, Redux Toolkit, React Query, react-hook-form, MMKV |

## Road24 infra / misc

| Repo | Role |
|------|------|
| `manifests` | K8s deploy manifests (RBAC, ingress-nginx, cert-manager, redis, mongodb, metabase, cronjobs, exporters) |
| `deep-links` | Static deep-link host (nginx + html) |
| `frontend` | Frontend deploy configs only (docker + kubernetes, no app) |
| `template_project` | React/Vite FSD boilerplate (Cypress, json-server, webpack) — starter template |

## NOT part of Road24 (separate products under the same ~/work)

| Repo | What it actually is |
|------|---------------------|
| `tgbot` | **SHADOW TRADES VIP** — AI trading-signal Telegram bot (aiogram 3 + FastAPI + Claude Vision). Org: nail228/alfagambit |
| `tgbot-admin` | Admin panel for the trading bot (alfasignalsai-admin), React + TS + Vite |
| `new-vision` | Clinic management system — separate product (React frontend + **Laravel** backend) |
| `KnowledgeHub` | Personal knowledge base (algorithms notes etc.), org nail228 |

> Treat these with their own conventions; don't apply Road24 rules to them. The Road24 GitHub org is
> `kashuz`; these live under `nail228` or are standalone.

## Cross-cutting conventions (Road24)

**Python FastAPI services:** clean 3-layer (Router → Service → Repository). Services expose
`execute()`. All async. Pydantic v2 at the boundary, constructor DI in routers. Full 3.12 type hints,
`StrEnum`, guard clauses, short functions. Alembic migrations. `uv` deps. `make up/down/test/migrate`.
`ruff check src/ && ruff format src/`, `mypy src/`. Tests `pytest` with markers
(`unit`/`repository`/`service`/`router`/`schema`). Messaging: RabbitMQ (insurance) + Celery; observability
via `road24-sdk`.

**road24-backend (Django/DRF):** thin views/serializers — NO business logic/ORM there. DTOs
(`@dataclass` in `dto/`) across boundaries. Services + repositories hold logic/data access. Soft
deletes (`BaseModel`), `@transaction.atomic` for multi-write, `update_fields` on save.
`python manage.py test apps.<app>`, `ruff check . --fix && ruff format .`.

**NestJS (nest-insurances):** Controller → Service → Repository, DTOs with `class-validator`, Swagger
decorators, TypeORM. `npm run lint`, `npm test` (jest).

**Frontends are heterogeneous — check the repo first.** Common: TypeScript, axios with Bearer
interceptor, i18n (react-intl or i18next), a shared `{code,message,details}` error envelope and
`?page=&limit=` pagination. **But state/UI libs differ:** dashboard = MUI + Redux Toolkit + React
Query + Formik; alimony/portofolio = lighter React + Redux/i18next; web = SvelteKit; landing =
Gatsby; new-webview = Vue; fortune = Next.js; mobile = Flutter/BLoC; native = RN + Redux + React
Query. Do NOT assume one frontend stack — read the target repo's `package.json` and existing features.

**Shared API contract:** camelCase JSON, `{code, message, details}` error envelope, `?page=&limit=`
pagination, JWT (Bearer) between services.

## The "second brain"

`road24-ai` is the central hub: reusable **role-grouped agents** (`agents/`), cross-stack **skills**
(`skills/`), and **knowledge** (this map + `knowledge/projects/*`). Per-repo `.claude/` dirs hold
project-local config; when a repo lacks an agent/skill, lift it from here or run
`bootstrap-claude-project`.
