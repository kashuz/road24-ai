---
paths:
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/tests/**"
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.spec.ts"
  - "**/__tests__/**"
  - "**/*_test.dart"
description: Cross-stack testing conventions (pytest, jest/vitest, flutter_test).
---

# Testing conventions

The clean layering is what makes tests cheap — test each layer in isolation.

## Always
- **AAA** (Arrange, Act, Assert); one behavior per test; the name states the behavior.
- **Behavior, not implementation** — assert the caller-facing contract, not private internals.
- **Mock at boundaries only** (DB/HTTP/time/randomness); never mock the unit under test.
- **Deterministic & isolated** — no real network, no `sleep`, no order-dependence, no shared mutable state.
- **Cover failure paths** (validation, auth, not-found, conflict/idempotency, empty/boundary), not just happy.
- No weakened/deleted assertions to make a build pass; no `skip` without a tracked reason.

## Per stack
- **pytest** (FastAPI): markers `unit`/`repository`/`service`/`router`/`schema`, async, fake repos / mocked httpx.
- **Django:** `manage.py test apps.<app>`, `factory_boy`, mock external gateways.
- **jest/vitest** (React/Nest): Testing Library query by role/label, mock the API (MSW); Nest services with mocked providers.
- **flutter_test:** `bloc_test` for state sequences, `mocktail` for repos, widget tests.

Coverage is a signal, not the goal — behavior tests beat a high % that tests internals.

> Deep rulebook: `skills/road24-conventions/references/testing.md`. Skill: `new-pytest-suite`/`new-nest-test`/`new-frontend-test`/`new-flutter-test`.
