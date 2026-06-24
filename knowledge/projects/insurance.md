# road24-insurance

**OSAGO insurance microservice** — mandatory vehicle-insurance management (calc, save, confirm,
policies) for the Road24 platform.

- **Repo:** kashuz/road24-insurance · **Stack:** Python 3.12, FastAPI, async SQLAlchemy, Pydantic v2,
  PostgreSQL, Redis, **RabbitMQ** (consumers + publisher), Celery, Alembic, `uv`.
- **Has `.claude/`:** yes — agents (engineer, security, tester), skills (new-command, new-endpoint,
  new-repo-method, new-service).

## Architecture
`Router → Service → Repository`. Services expose `execute()`. All async. Pydantic v2 schemas at the
boundary; constructor DI in routers; repositories return DTOs/domain objects.

## Structure (`src/`)
`main.py` · `routers/` · `services/` · `repositories/` · `schemas/` · `models.py` · `enums.py` ·
`filters/` · `dependencies/` · `tasks/` (Celery) · `consumers/` + `publisher/` + `broker.py`
(RabbitMQ messaging) · `commands/` + `cli.py` · `constants/` · `utils.py`. Infra in `core/`. Migrations
in `alembic/`.

## Commands
```bash
uv sync && source .venv/bin/activate
make start            # first-time (pre-commit, build)
make up | down | restart | logs | test | migrate
pytest -m unit|repository|service|router|schema     # markers
pytest --cov=src --cov=core --cov-report=html
ruff check src/ && ruff format src/ ; mypy src/
docker exec -it road24-insurance-app alembic revision --autogenerate -m "msg"
```

## Conventions & gotchas
- Payment/insurance flows must be **idempotent** (hold/confirm); guard against replay & races.
- RabbitMQ: consumers in `consumers/`, publishing via `publisher/`+`broker.py` — follow existing
  message contracts. Celery for background work.
- Pre-commit runs ruff-format, ruff, bandit, pytest. Tests live in `tests/` with markers.

## Integrations
Calls Backend Core (payments), databanks (person/vehicle verify). Consumed by `bff`/`gateway`.
Observability via `road24-sdk`.
