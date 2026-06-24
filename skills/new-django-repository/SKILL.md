---
name: new-django-repository
description: Scaffold a Repository for road24-backend that encapsulates ORM/cache/external access, keeping queries out of views/serializers/services. Use for "add data access for X", "centralize the Y queries", "new repository in apps.Z".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[app] [repository-name] [methods]"
---

# Create a Django Repository (road24-backend)

Repository for: $ARGUMENTS

Repositories are the only place that touches the ORM (or cache/external APIs). Services call them;
views/serializers never query directly. They live in `apps/<app>/repositories/`.

## Steps

1. **Read first** — a sibling repository, the model, and `.claude/concepts/django-patterns.md`
   (query perf, `select_related`/`prefetch_related`). Match patterns.
2. Implement focused query methods; optimize for N+1; respect soft deletes.
3. Inject the repository into services (constructor, with a default instance) for testability.

## Template

```python
from apps.transactions.models import Hold


class HoldRepository:
    def get(self, hold_id: int) -> Hold | None:
        return Hold.objects.filter(id=hold_id).select_related("vehicle").first()

    def active_for_vehicle(self, vehicle_id: int) -> Hold | None:
        return Hold.objects.filter(
            vehicle_id=vehicle_id, status=Hold.Status.PENDING
        ).first()

    def create(self, *, vehicle_id: int, amount: int) -> Hold:
        return Hold.objects.create(vehicle_id=vehicle_id, amount=amount)
```

## Rules

- All ORM access lives here — no `Model.objects` calls in views/serializers/services.
- Prevent N+1 with `select_related`/`prefetch_related`; only fetch needed fields (`.only()`/`.values()` where apt).
- Respect soft deletes (`BaseModel` default manager). Wrap multi-write callers in `@transaction.atomic`
  (usually in the service); use `update_fields` on saves.
- Return models/DTOs; one repository per aggregate. Enforce ownership filters to avoid IDOR at the query level.
