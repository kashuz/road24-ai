---
name: new-django-dto
description: Scaffold a DTO (@dataclass) for road24-backend that carries data across the View → Serializer → Service → Repository boundaries. Use for "add a DTO for X", "pass Y between layers cleanly".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[app] [dto-name] [fields]"
---

# Create a Django DTO (road24-backend)

DTO for: $ARGUMENTS

DTOs are frozen `@dataclass`es in the app's `dto/` package. They decouple layers: the serializer
builds a DTO from validated input, the service consumes it. No Django/ORM imports in DTOs.

## Steps

1. **Read first** — `apps/<app>/dto/` for existing DTOs and the serializer's `to_dto()` pattern.
2. Define the DTO with explicit, fully-typed fields; `frozen=True`.
3. Have the serializer build it (`to_dto()`); have the service accept it as input.

## Template

```python
from dataclasses import dataclass

from apps.gauth.models import User


@dataclass(frozen=True)
class CreateHoldDTO:
    user: User
    vehicle_id: int
    amount: int
```

```python
# serializer
def to_dto(self, user) -> CreateHoldDTO:
    return CreateHoldDTO(user=user, **self.validated_data)
```

## Rules

- `frozen=True`, full type hints. One DTO per use case (input DTOs ≠ output DTOs).
- No business logic, no ORM queries, no framework imports beyond model types for typing.
- Pass DTOs across every layer boundary — don't pass raw `request.data` or `validated_data` into services.
- Keep DTOs in `dto/`, mirroring the app's structure.
