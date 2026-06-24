---
name: wire-sdk-observability
description: Wire road24-sdk structured logging + Prometheus metrics into a Road24 service (FastAPI/httpx/redis/sqlalchemy/faststream) via init() + integrations, with trace-context propagation. Use for "add observability to X", "set up logging/metrics", "instrument the Y service".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[repo] [which integrations]"
---

# Wire road24-sdk Observability

Instrument: $ARGUMENTS

`road24-sdk` provides Sentry-style structured JSON logging + Prometheus metrics with framework
integrations. See `knowledge/projects/sdk.md` for its internals. Available integrations:
`fastapi`, `httpx`, `redis`, `sqlalchemy`, `faststream`.

## Steps

1. **Read first** — how a sibling service already calls `road24_sdk.init(...)` (usually in
   `core/` at app startup) and which integrations it enables. Match it.
2. Add `road24-sdk` to deps (`uv add road24-sdk` / pyproject) if missing.
3. Call `init()` once at startup with the integrations the service actually uses.
4. For FastAPI, also `.setup(app)` the FastAPI integration (it needs the app instance). httpx/redis/
   sqlalchemy integrations auto-patch at class level via `setup_once()` (called by `init()`); use
   `.setup(client)` only for a specific instance.
5. Confirm metrics are exposed (Prometheus endpoint) and logs are structured JSON with trace ids.

## Init pattern

```python
import road24_sdk
from road24_sdk.integrations.fastapi import FastApiLoggingIntegration
from road24_sdk.integrations.httpx import HttpxLoggingIntegration
from road24_sdk.integrations.redis import RedisLoggingIntegration
from road24_sdk.integrations.sqlalchemy import SqlalchemyLoggingIntegration

road24_sdk.init(
    service_name="road24-insurance",
    log_level="INFO",
    integrations=[
        HttpxLoggingIntegration(),
        RedisLoggingIntegration(),
        SqlalchemyLoggingIntegration(),
    ],
)

# FastAPI needs the app instance:
fastapi_integration = FastApiLoggingIntegration()
fastapi_integration.setup(app)
```

## Rules

- `init()` once, at startup — not per request. Only enable integrations the service uses.
- Trace ids propagate via `ContextVar` — don't pass them manually; don't spawn threads that lose context.
- Body/PII is sanitized by the SDK's `_sanitizer` — still never log secrets yourself.
- Match `service_name` to the repo. Verify the Prometheus scrape target / metrics route after wiring.
- Extending the SDK itself (new integration)? That's a `python-fastapi-engineer` change in road24-sdk:
  implement both `setup_once()` and `.setup()`, inherit the `Integration` ABC.
