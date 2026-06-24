---
name: new-django-service
description: Scaffold a business-logic Service for road24-backend (View → Serializer → DTO → Service → Repository) with execute(), DI, and transaction handling. Use for "add a service for X", "extract logic out of the view/serializer", "orchestrate the Y flow".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[app] [service-name] [what it does]"
---

# Create a Django Service (road24-backend)

Service for: $ARGUMENTS

Services hold the business logic. They take a DTO (and injected repositories), expose `execute()`,
and wrap multi-write flows in transactions. Views/serializers stay thin.

## Steps

1. **Read first** — a sibling service in `apps/<app>/services/`, the DTO it consumes, the repositories
   it uses, and `.claude/concepts/clean-architecture.md`.
2. **Search** for an existing service that already does this.
3. Inject repositories (constructor + defaults); put logic in `execute()`; guard clauses for edge cases.
4. `@transaction.atomic` for multi-write; raise domain exceptions for the view/handler to map.
5. Add tests (`new-pytest-suite` / `apps.<app>` tests) with mocked repositories.

## Template

```python
from django.db import transaction

from apps.transactions.dto.hold import CreateHoldDTO
from apps.transactions.repositories.hold import HoldRepository


class CreateHoldService:
    def __init__(self, dto: CreateHoldDTO, repo: HoldRepository | None = None) -> None:
        self._dto = dto
        self._repo = repo or HoldRepository()

    def execute(self):
        if self._repo.active_for_vehicle(self._dto.vehicle_id):
            raise HoldAlreadyActive()
        with transaction.atomic():
            return self._repo.create(
                vehicle_id=self._dto.vehicle_id, amount=self._dto.amount
            )
```

## Rules

- One responsibility per service; orchestrate repositories — no direct `Model.objects` calls.
- Inject deps (defaults for prod, fakes in tests). Take a DTO in, not `request`/`validated_data`.
- `@transaction.atomic` around multi-write; `update_fields` on saves; soft deletes only.
- Raise domain exceptions; let the view translate to HTTP. Full type hints, `logger`, enums, guard clauses.
- Fix N+1 and security (IDOR, secret/PII leak) in flows you touch. YAGNI.
