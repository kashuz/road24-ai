---
name: new-fastapi-service
description: Scaffold a business-logic Service (with execute()) for a Road24 FastAPI service (insurance, gateway, bff, localization, tinting). Use for "add a service for X", "extract this logic into a service", "orchestrate the Y flow".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[repo] [service-name] [what it does]"
---

# Create a FastAPI Service

Service for: $ARGUMENTS

Services hold the business logic in `Router → Service → Repository`. They expose `execute()`, take
their dependencies via the constructor (DI), and are fully async + typed. No HTTP/framework concerns
inside — that's the router's job.

## Steps

1. **Read first** — a sibling service in `src/services/`, the repository it will use, and the schemas
   it returns. Match naming, error handling, and DI style.
2. **Search** for an existing service that already does this (don't duplicate orchestration).
3. Define inputs/outputs as Pydantic schemas or DTOs; inject repositories/clients in `__init__`.
4. Put the logic in `execute()`; keep it small (extract private helpers); guard clauses for edge cases.
5. Add a service-layer test (`pytest -m service`) with mocked repositories.

## Template

```python
from src.repositories.hold import HoldRepository
from src.schemas.hold import CreateHoldRequest, HoldResponse


class CreateHoldService:
    def __init__(self, repo: HoldRepository, payload: CreateHoldRequest) -> None:
        self._repo = repo
        self._payload = payload

    async def execute(self) -> HoldResponse:
        existing = await self._repo.find_active(self._payload.vehicle_id)
        if existing is not None:
            return HoldResponse.model_validate(existing)  # idempotent
        hold = await self._repo.create(self._payload)
        return HoldResponse.model_validate(hold)
```

## Rules

- One responsibility per service; orchestrate repositories, don't reach into the DB/HTTP directly.
- Async throughout; no blocking I/O. Constructor DI so it's unit-testable with fakes.
- Idempotent for payment/insurance flows; raise domain exceptions, let the router map them to HTTP.
- Full type hints, `StrEnum`, guard clauses, `logger` not `print`, functions short.
- Repositories return DTOs/domain objects — don't let raw ORM rows flow through the service to the router.
