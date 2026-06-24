# Testing

How every agent writes and judges tests across the suite. The layering
([clean-architecture.md](clean-architecture.md) + [feature-sliced-design.md](feature-sliced-design.md))
is what makes this cheap — test each layer in isolation. Per-stack recipes: `new-pytest-suite`,
`new-nest-test`, `new-frontend-test`, `new-flutter-test`.

## Principles

- **AAA** — Arrange, Act, Assert. One behavior per test; the name states the behavior
  (`rejects_second_active_hold`).
- **Test behavior, not implementation.** Assert on the contract a caller relies on — inputs→outputs,
  emitted states, rendered UI by role — not private internals. Refactors shouldn't break good tests.
- **Mock at boundaries only.** Fake repositories/HTTP/DB/time/randomness; never mock the thing under
  test. Services test with fake repositories; repositories test against their real backend (or a
  faithful test double); components mock the API layer (MSW/axios mock).
- **Determinism.** No real network, no `sleep`, no wall-clock/random without injection, no order
  dependence, no shared mutable state. A test passes or fails for one reason.
- **Cover the unhappy paths.** Validation errors, auth/permission failures, not-found, conflict/
  idempotency, empty/boundary inputs, upstream failure — not just the happy path.
- **Right level.** Prefer fast unit tests at the service/logic layer; use integration/e2e for wiring
  and contracts; don't push everything to slow e2e. Don't test framework internals or trivial getters.

## Per-stack

- **FastAPI:** `pytest` with markers (`unit`/`repository`/`service`/`router`/`schema`), async tests;
  fake repositories for services, mocked httpx for HTTP repos.
- **Django:** `python manage.py test apps.<app>`, `factory_boy` fixtures, mock external gateways.
- **NestJS:** `jest` — services with mocked providers (`Test.createTestingModule`), e2e with supertest.
- **React:** Testing Library (vitest/jest), query by role/label, mock the API (MSW), assert loading/
  empty/error + error-envelope→field mapping.
- **Flutter:** `bloc_test` for state sequences, `mocktail` for repositories, widget tests for UI.

## Hard rules (reviewer enforces)

1. New/changed logic ships with tests; the suite must be green before "done".
2. AAA, one behavior per test, behavior-focused assertions, descriptive names.
3. Deterministic and isolated — no network/sleep/order-dependence/shared state.
4. Failure paths covered, not only the happy path.
5. No weakened/deleted assertions to make a build pass; no `skip` without a tracked reason.

Coverage is a signal, not the goal — a green suite that tests behavior beats a high % that tests internals.
