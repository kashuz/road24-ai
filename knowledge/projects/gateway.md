# road24-gateway

**Thin API gateway** for the Road24 platform — a unified entry that routes/forwards to backend
services. Minimal logic (routing + auth), distinct from `bff` which aggregates.

- **Repo:** kashuz/road24-gateway · **Stack:** Python 3.12, FastAPI, httpx (async), JWT, `uv`.
- **Has `.claude/`:** yes — CLAUDE.md + agents (engineer, tester). Branch: `main`.

## Architecture
`Router → Service(http)`. Very small surface. `src/` = `main.py`, `dependencies.py`, `routers/`.
All async; httpx.AsyncClient to downstream services; JWT auth via dependencies.

> Note: its README is shared with the BFF template ("Backend for Frontend") — but the codebase is the
> thin gateway (routers only). Confirm intent against `routers/` before assuming BFF-style aggregation.

## Commands
```bash
make start ; make up | down | restart | logs | test
pytest ; pytest -v ; pytest --cov=src
ruff check src/ ; ruff format src/ ; mypy src/
```

## Conventions
- Keep it thin — routing, auth, request forwarding. Push real logic to the owning service or `bff`.
- Propagate JWT/identity downstream; don't trust unverified client headers.
- Full type hints, async, guard clauses.

## Integrations
Front door to `road24-insurance`, `road24-backend`, `bff`. Observability via `road24-sdk`.
