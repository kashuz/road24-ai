---
paths:
  - "**/*.py"
description: Django/DRF conventions for road24-backend (core monolith, legacy → clean architecture).
---

# Django/DRF conventions (road24-backend)

Clean architecture: **View → Serializer → DTO → Service → Repository**. (Install in road24-backend;
FastAPI repos use `backend-fastapi` instead — both are `.py`.)

## Architecture
- Thin views/serializers — NO business logic or ORM/external calls there; that's services + repositories.
- DTOs (`@dataclass` in `dto/`) cross every layer boundary — don't pass `request`/`validated_data` in.
- Inject deps (constructor + defaults) for testability.

## Style
- Full type hints, `logger` not `print`, `TextChoices`/enums not magic strings, guard clauses, reuse before adding.

## Data
- Soft deletes only (`BaseModel`) — never hard-delete domain rows. `@transaction.atomic` for multi-write;
  `.save(update_fields=[...])`. Index FKs/filter columns; fix N+1 with `select_related`/`prefetch_related`.

## Security
- Permission classes + authorize the specific object (no IDOR). Validate input; no raw SQL/`.raw()` with
  input. Never leak secrets/PII in responses or logs.

## Tests
- `python manage.py test apps.<app>`, `factory_boy` fixtures, AAA, mock external gateways; cover failure
  paths. `ruff check . --fix && ruff format .` before "done".

> Deep rulebook: `skills/road24-conventions/references/{clean-architecture,clean-code,security,testing}.md`.
> Repo-local `.claude/concepts/django-patterns.md` is more specific — it wins. Skills: `new-drf-endpoint`, `new-django-*`.
