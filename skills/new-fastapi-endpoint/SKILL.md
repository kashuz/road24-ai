---
name: new-fastapi-endpoint
description: Scaffold a clean-architecture FastAPI endpoint (router → service → repository + Pydantic schemas) for the Road24 FastAPI services (insurance, gateway, bff, localization, tinting).
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[repo] [method] [path] [description]"
---

# Create a New FastAPI Endpoint

Create an endpoint for: $ARGUMENTS

Target repos: `road24-insurance`, `road24-gateway`, `road24-bff`, `road24-localization`,
`road24-tinting`. Architecture: **Router → Service → Repository**, all async, Pydantic v2 schemas at
the boundary, constructor DI in routers, services expose `execute()`.

## Steps

1. **Read first** — existing routers in `src/routers/v1/`, a sibling service in `src/services/`, a
   repository in `src/repositories/`, and the repo's `.claude/CLAUDE.md`. Match their patterns.
2. **Search** for an existing service/repository that already does this before writing new ones.
3. Build bottom-up: schema → repository (if new data access) → service → thin router → register route.
4. Run `ruff check src/ && ruff format src/`, `mypy src/`, and `pytest -m router` (+ relevant markers).

## Schema (Pydantic v2, boundary)

```python
from pydantic import BaseModel, ConfigDict, Field


class CreateHoldRequest(BaseModel):
    model_config = ConfigDict(populate_by_name=True)
    amount: int = Field(gt=0)
    vehicle_id: int = Field(alias="vehicleId")


class HoldResponse(BaseModel):
    id: int
    status: str
```

## Service (business logic, `execute()`)

```python
class CreateHoldService:
    def __init__(self, repo: HoldRepository, payload: CreateHoldRequest) -> None:
        self._repo = repo
        self._payload = payload

    async def execute(self) -> HoldResponse:
        hold = await self._repo.create(self._payload)
        return HoldResponse(id=hold.id, status=hold.status)
```

## Router (thin — validate, build deps, call service)

```python
from fastapi import APIRouter, Depends, status

router = APIRouter(prefix="/v1/holds", tags=["holds"])


@router.post("", response_model=HoldResponse, status_code=status.HTTP_201_CREATED)
async def create_hold(
    payload: CreateHoldRequest,
    repo: HoldRepository = Depends(get_hold_repository),
    user=Depends(get_auth_user),
) -> HoldResponse:
    return await CreateHoldService(repo=repo, payload=payload).execute()
```

## Rules

- No business logic or external/DB calls in the router — only validation, DI, and the service call.
- Repository returns DTOs/domain objects, not raw ORM rows leaking past the boundary.
- Full type hints, `StrEnum` for statuses, guard clauses, functions short.
- camelCase aliases on the wire; map IDOR-prone resources through ownership checks.
- Add/extend tests by marker (`router`, `service`, `repository`, `schema`).
