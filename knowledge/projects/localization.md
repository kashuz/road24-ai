# road24-localization

**Localization / i18n service** (translations management) for the Road24 platform. The repo also
houses **FastAPI mocks** for external services integrated with Road24 (per its README) — useful for
local/dev and testing integrations.

- **Repo:** kashuz/road24-localization · **Stack:** Python 3.12, FastAPI, SQLAlchemy, Alembic, `uv`.
- **Has `.claude/`:** yes — CLAUDE.md + agents (engineer, security, tester). Branch:
  `feature/RDFT-2641-localization-service`.

## Architecture
`Router → Service → Repository`. `src/` = `main.py` · `router/` · `services/` · `repositories/` ·
`schemas/` · `models.py` · `filters/` · `dependencies/`. Migrations in `alembic/`. Infra in `core/`.

## Commands
```bash
make up | down | restart | logs | test ; make migrate
pytest ; pytest --cov=src
ruff check src/ ; ruff format src/ ; mypy src/
```

## Conventions
- Standard FastAPI clean-3-layer (see `platform-map.md`). Async, Pydantic v2, full type hints.
- Keep the **localization service** and the **external-service mocks** clearly separated; don't ship
  mock endpoints into the real service surface.

## Integrations
Provides translations to clients/services; mocks stand in for external/government APIs during dev.
