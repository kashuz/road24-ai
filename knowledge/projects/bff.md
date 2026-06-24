# road24-bff

**Backend-for-frontend** — a unified API layer that aggregates multiple backend services for the
clients, focused on OSAGO insurance operations (calc, save, confirm + payment orchestration).

- **Repo:** kashuz/road24-bff · **Stack:** Python 3.12, FastAPI, httpx (async), Redis, Celery, JWT, `uv`.
- **Has `.claude/`:** yes — CLAUDE.md + agents (engineer, tester). Branch: `main`.

## Architecture
`Router → Service → Repository(http)`. Routers (validation/auth/DI) → Services (`execute()`,
orchestration) → Repositories (`repositories/http/`, external API clients). All async.

## Structure (`src/`)
`main.py` · `routers/` · `services/` · `repositories/` (http) · `schemas/` · `enums/` ·
`dependencies/` · `publisher/` · `tasks/` (Celery) · `utils.py`. Infra in `core/` (settings,
dependencies: `auth.py` `get_auth_user`, `http_clients.py`, `redis_clients.py`).

## External services it calls
- **Insurance Service** — OSAGO ops (calc/save/confirm)
- **Backend Core** — payment processing
- **Databank** — person/vehicle verification

## Commands
```bash
make start ; make up | down | restart | logs | test
pytest ; pytest tests/services/insurance/ ; pytest --cov=src/services
ruff check src/ ; ruff format src/ ; mypy src/
```

## Conventions
- Services orchestrate calls to multiple repositories; keep them async and idempotent for payment flows.
- Tests focus on the **service layer** (90%+ coverage target). Constructor DI in routers.
- Cache via Redis where it reduces downstream load. Observability via `road24-sdk`.
