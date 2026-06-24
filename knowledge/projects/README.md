# Road24 Projects — Knowledge Base

Per-project deep-dives. The high-level table is in `../platform-map.md`; this folder holds the detail
agents need before working in a repo. All Road24 repos are under the **kashuz** GitHub org; paths are
relative to `~/work`.

## Index

### Backend services
- [road24-backend](backend.md) — Django/DRF core monolith
- [road24-insurance](insurance.md) — FastAPI OSAGO microservice (RabbitMQ + Celery)
- [road24-gateway](gateway.md) — thin FastAPI gateway
- [road24-bff](bff.md) — FastAPI backend-for-frontend
- [road24-localization](localization.md) — FastAPI i18n + external mocks
- [road24-tinting](tinting.md) — FastAPI tinting permits (early)
- [road24-sdk](sdk.md) — shared logging/metrics SDK
- [nest-insurances](nest-insurances.md) — NestJS insurance gateway

### Clients
- [road24-dashboard](dashboard.md) — React + MUI + Redux admin
- [road24-web](web.md) — SvelteKit web app
- [road24-insurance-webview](webviews.md) — pnpm MFE monorepo
- [road24-landing](landing.md) — Gatsby landing
- [road24-mobile](mobile.md) — Flutter app
- [R24NativeInsurance](native-insurance.md) — React Native client
- [misc-frontends](misc-frontends.md) — alimony, portofolio, fortune, new-webview, frontend, template_project

### Infra & non-road24
- [infra](infra.md) — manifests, deep-links
- [non-road24](non-road24.md) — tgbot, tgbot-admin, new-vision, KnowledgeHub (separate products)

## How to use

Before working in a repo: read its file here + the repo's own `.claude/CLAUDE.md` (if present). When
you learn something durable about a project (a command, a gotcha, an integration), update its file
here so the whole suite benefits.
