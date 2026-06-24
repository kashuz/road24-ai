---
name: new-pydantic-schema
description: Scaffold Pydantic v2 request/response schemas for a Road24 FastAPI endpoint — camelCase aliases, validation, and the shared error/pagination envelope. Use for "add the schema for X", "validate the Y request", "define the response model".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[repo] [resource] [fields]"
---

# Create Pydantic Schemas

Schemas for: $ARGUMENTS

Pydantic v2 models live at the boundary (`src/schemas/`). Requests validate input; responses shape
output. The wire is **camelCase**; pagination is `?page=&limit=`; errors use `{code, message, details}`.

## Steps

1. **Read first** — sibling schemas in `src/schemas/`, the shared base/config (alias generator,
   pagination wrapper, error envelope), and the service's input/output.
2. Define request + response models; add field validation and camelCase aliases.
3. Reuse the shared paginated wrapper for list endpoints; don't redefine envelopes.

## Template

```python
from pydantic import BaseModel, ConfigDict, Field, field_validator


class _Base(BaseModel):
    model_config = ConfigDict(populate_by_name=True, from_attributes=True)


class CreateHoldRequest(_Base):
    amount: int = Field(gt=0)
    vehicle_id: int = Field(alias="vehicleId")

    @field_validator("amount")
    @classmethod
    def _max(cls, v: int) -> int:
        if v > 100_000_000:
            raise ValueError("amount too large")
        return v


class HoldResponse(_Base):
    id: int
    status: str
    vehicle_id: int = Field(serialization_alias="vehicleId")
```

## Rules

- `populate_by_name=True` + aliases for camelCase wire / snake_case Python. `from_attributes=True` to
  build responses straight from ORM/domain objects.
- Validate at the boundary (ranges, formats, enums via `StrEnum`); fail fast with clear messages.
- Reuse the repo's shared paginated/envelope wrappers — match the contract (see `cross-service-contract`).
- Don't put business logic in schemas; no DB/HTTP calls. Keep request and response models separate.
