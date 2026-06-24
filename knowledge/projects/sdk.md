# road24-sdk

**Shared Python SDK** for structured JSON logging + Prometheus metrics across the Road24
microservices. Sentry-SDK-like pattern with framework integrations.

- **Repo:** kashuz/road24-sdk · **Stack:** Python 3.12, dataclasses (`slots=True`), `StrEnum`,
  `prometheus_client`, `httpx`, `redis`, `sqlalchemy`. **Has `.claude/`:** yes (CLAUDE.md + agents).

## Public API
`road24_sdk.init(service_name=..., log_level=..., integrations=[...])` — Sentry-style. `configure()`
+ enums also exported.

## Module structure (`road24_sdk/`)
`__init__.py` (public API) · `_types.py` (Road24Config + StrEnums) · `_schemas.py` (dataclass log
attrs) · `_formatter.py` (LogFormatter, setup_logging, trace context) · `_sanitizer.py` (body
sanitization) · `metrics/` (`http.py`, `db.py`, `redis.py`) · `integrations/`
(`_base.py`, `fastapi.py`, `faststream.py`, `httpx.py`, `redis.py`, `sqlalchemy.py`).

## Key patterns
- **Integration ABC** — every integration implements `setup_once()` (class-level patching, called via
  `init()`) **and** `.setup(client)` (instance-level). `FastApiLoggingIntegration` needs `.setup(app)`.
- **Trace context** via `ContextVar` (thread-safe across async).
- **Metrics** record both duration (Histogram) and count (Counter) with normalized labels.

## Conventions (strict)
Full type hints (3.12), `StrEnum`, dataclasses with `slots=True`, `ContextVar` for request-scoped
state (no globals), async for async utils, guard clauses, functions < 20 lines, minimal comments.

## When extending
Add a new integration → implement both `setup_once()` and `.setup()`, inherit `Integration` ABC.
Use the `wire-sdk-observability` skill to consume the SDK from a service.

## Commands
`uv sync` · `pytest` (+ `--cov`) · `ruff check . ; ruff format .` · `mypy`.
