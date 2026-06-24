---
name: new-fastapi-repository
description: Scaffold a Repository for a Road24 FastAPI service — either a DB repository (async SQLAlchemy, e.g. road24-insurance/localization) or an HTTP repository (httpx client to another service, e.g. bff/gateway). Use for "add data access for X", "a client for the Y service", "new repo method".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[repo] [db|http] [entity/target] [methods]"
---

# Create a FastAPI Repository

Repository for: $ARGUMENTS

Repositories are the only layer that touches the DB or external HTTP. They return DTOs/domain objects
(or Pydantic models) — never leak raw ORM rows or raw responses to the service.

## Steps

1. **Read first** — a sibling repository (`src/repositories/` — DB; `src/repositories/http/` — HTTP),
   the session/client dependency providers in `core/dependencies/`, and the entity/schema involved.
2. Pick the kind: **DB** (async SQLAlchemy) or **HTTP** (httpx.AsyncClient to another service).
3. Implement focused methods; map rows/responses to domain objects; handle not-found + upstream errors.
4. Add a repository-layer test (`pytest -m repository`) — DB with a test session, HTTP with mocked httpx.

## DB repository (async SQLAlchemy)

```python
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.models import Hold


class HoldRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get(self, hold_id: int) -> Hold | None:
        result = await self._session.execute(select(Hold).where(Hold.id == hold_id))
        return result.scalar_one_or_none()

    async def create(self, **fields) -> Hold:
        hold = Hold(**fields)
        self._session.add(hold)
        await self._session.flush()
        return hold
```

## HTTP repository (bff/gateway → another service)

```python
import httpx


class InsuranceRepository:
    def __init__(self, client: httpx.AsyncClient) -> None:
        self._client = client

    async def calc(self, payload: dict) -> dict:
        resp = await self._client.post("/v1/osago/calc", json=payload)
        resp.raise_for_status()
        return resp.json()
```

## Rules

- Repositories don't contain business logic — just data access + mapping. One repository per aggregate/target.
- Async; inject the session/client (don't create them inside). Avoid N+1 — eager-load (`joinedload`) when needed.
- Handle not-found (return `None` or raise a domain error) and upstream failures (timeout/5xx) explicitly.
- Propagate JWT/trace headers on HTTP calls; never leak secrets. Return DTOs/models, not raw rows.
