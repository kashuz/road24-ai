# Clean Architecture

The layering rule for every Road24 backend (Django, FastAPI, NestJS) and the mobile data layer
(Flutter). One sentence: **dependencies point inward; the framework/transport boundary holds no
business logic.**

## The dependency rule

Outer layers depend on inner layers, never the reverse. Business logic does not import the web
framework, the ORM models, or HTTP clients directly — those are details behind a boundary.

```
            (transport / framework — a detail)
  Router / View / Controller / Widget
            │  validate input, build a DTO/schema, call a service, map result→response
            ▼
  Service            ← business logic, orchestration, transactions; exposes execute()
            │  depends on repository *interfaces*, not concretions
            ▼
  Repository         ← the ONLY layer that touches DB / cache / external HTTP
            │
            ▼
  Models / external systems (details)
```

Data crosses boundaries as **DTOs / schemas**, never as raw request objects or raw ORM rows.

## Responsibilities (what goes where)

- **Boundary (Router/View/Controller/Widget):** parse + validate input, authn/authz, dependency
  injection, call exactly one service, translate the result or domain error into a response. **No**
  business rules, **no** DB/HTTP calls, **no** orchestration.
- **Service:** the business logic. Orchestrates one or more repositories, owns transactions and
  invariants, is idempotent for payment/insurance flows, raises **domain** exceptions. Exposes
  `execute()`. Takes a DTO/schema in; returns a DTO/domain object out. Constructor DI so it's testable.
- **Repository:** all data access (ORM queries, cache, external APIs). Maps storage/wire shapes to
  domain objects/DTOs. No business logic. One repository per aggregate/external target.
- **DTO / schema:** the typed contract between layers and on the wire. No logic.

## Per-stack mapping

| Stack | Boundary | Service | Repository |
|-------|----------|---------|------------|
| FastAPI services | Router (`routers/`) | Service (`services/`, `execute()`) | Repository (`repositories/`, DB or `http/`) |
| Django/DRF (road24-backend) | View → Serializer (+ **DTO**) | Service (`services/`) | Repository (`repositories/`) |
| NestJS (nest-insurances) | Controller (+ DTO) | Service (`@Injectable`) | Repository (TypeORM) |
| Flutter (road24-mobile) | Widget + BLoC/Cubit | Cubit/Bloc logic | Repository (dio) |

## Hard rules (the reviewer enforces these)

1. No business logic, ORM queries, or external/HTTP calls in a Router/View/Serializer/Controller/Widget.
2. Cross every layer boundary with a DTO/schema — never `request.data`/`validated_data`/raw rows.
3. Inject dependencies (constructor, with defaults) — no `new`/global singletons inside services.
4. Repositories return domain objects/DTOs; ORM/wire types do not leak past them.
5. Services raise domain errors; the boundary maps them to HTTP/UI. Transactions live in the service.
6. Each layer is independently testable: service with fake repositories, repository against its backend.

## Why

Testability (mock at boundaries), replaceability (swap ORM/HTTP without touching logic), and a single
obvious home for every kind of change. See [clean-code.md](clean-code.md) for SOLID/DRY/KISS that
keep each layer healthy, and [testing.md](testing.md) for how the layering enables fast tests.
