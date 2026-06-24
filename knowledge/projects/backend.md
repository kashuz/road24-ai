# road24-backend

**Core monolith.** Django 4.2 + DRF backend for the Road24 vehicle-management platform (Uzbekistan):
vehicle registration, payments, fines, insurance hooks, lotto, notifications, government integrations.
Legacy codebase being refactored toward clean architecture.

- **Repo:** kashuz/road24-backend · **Stack:** Python 3.10, Django 4.2 + DRF, PostgreSQL 15/PostGIS,
  Redis 7, Celery (+ beat/flower), Firebase Admin, Telegram Bot API, OneID SSO, `uv`.
- **Has `.claude/`:** yes — agents (coordinator, engineer, tester, reviewer, developer), skills
  (new-dto, new-repository, new-service, new-endpoint, new-test), concepts (clean-architecture,
  clean-code, django-patterns, security), research/ (known antipatterns/bottlenecks/vulns).

## Architecture

`View → Serializer → DTO → Service → Repository`. Thin views/serializers — **no business logic or
ORM/external calls there**. DTOs are `@dataclass` in each app's `dto/`. Services + repositories hold
logic and data access. Soft deletes via `BaseModel`; `@transaction.atomic` for multi-write;
`.save(update_fields=[...])`.

## Apps (`apps/`)

advertisement · bank_cards · bot · cars · external · fcm_django · files · gauth · geo · handbooks ·
insurance · logs · lotto · notifications · one_id · petrol_spy · settings · shared · telegram_bot ·
test_support · transactions

`transactions` (payments/holds) and `cars` are the hot paths; `shared` holds `BaseModel` and common
utils; `external`/`one_id` wrap government/SSO integrations.

## Commands

```bash
make run                      # dev server (no Docker)
make init_local               # initial Docker setup
make migrate ; python manage.py makemigrations
python manage.py test apps.<app>            # tests (e.g. apps.transactions)
ruff check . --fix && ruff format .         # lint + format (ruff.toml)
make worker | low_priority_worker | high_priority_worker | beat | flower   # Celery
python manage.py shell ; compilemessages    # utils
```

## Conventions & gotchas

- Reuse before adding — search for an existing service/repository first (legacy has duplicates).
- factory_boy for test fixtures; AAA; mock external calls/gateways.
- Full type hints, `logger` not `print`, enums not magic strings, guard clauses.
- Fix N+1 (`select_related`/`prefetch_related`) and IDOR/secret-leak as you touch code.
- `.claude/research/*` lists known issues — don't reproduce them; reviewer flags regressions.

## Integrations

Consumed by `road24-bff`/`road24-gateway` (payment processing) and clients. Talks to OneID, databanks,
payment gateways, Firebase (FCM), Telegram. PostGIS for geo.
