---
name: new-pytest-suite
description: Scaffold tests for a Road24 Python service — pytest with markers (unit/repository/service/router/schema) for FastAPI services, or Django tests with factory_boy for road24-backend. Use for "write tests for X", "raise coverage on Y", "add service/repository tests".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[repo] [module/layer to test]"
---

# Create a Python Test Suite

Tests for: $ARGUMENTS

Detect the framework first: **FastAPI services** → `pytest` (+ markers, async); **road24-backend** →
Django test runner + `factory_boy`. AAA layout, behavior over implementation, mock at boundaries.

## Steps

1. **Read first** — existing tests (`tests/` or `apps/<app>/tests/`), fixtures/factories, and the
   repo's coverage target. Copy the structure.
2. Cover happy path + edge cases + failure paths (validation, auth, not-found, conflict).
3. Mock external boundaries (DB session/httpx/time/randomness); keep tests deterministic.
4. Run and report pass/fail + coverage delta.

## FastAPI (pytest + markers)

```python
import pytest


@pytest.mark.service
async def test_create_hold_is_idempotent(hold_repo_fake):
    hold_repo_fake.active = existing_hold
    result = await CreateHoldService(repo=hold_repo_fake, payload=payload).execute()
    assert result.id == existing_hold.id
    hold_repo_fake.create.assert_not_called()
```
Run: `pytest -m service` · `pytest -m "repository or router"` · `pytest --cov=src --cov=core`.

## Django (factory_boy + AAA)

```python
from django.test import TestCase


class CreateHoldServiceTests(TestCase):
    def test_rejects_second_active_hold(self):
        car = CarFactory()
        HoldFactory(vehicle=car, status=Hold.Status.PENDING)        # Arrange
        with self.assertRaises(HoldAlreadyActive):                  # Act + Assert
            CreateHoldService(dto=CreateHoldDTO(user=..., vehicle_id=car.id, amount=100)).execute()
```
Run: `python manage.py test apps.<app>`.

## Rules

- AAA; one behavior per test; descriptive names. Cover failure paths, not just the happy one.
- Mock at boundaries — no real network, no sleeping, no shared mutable state, no order dependence.
- Don't test framework internals or trivial getters. Use the marker that matches the layer (FastAPI).
- Keep fixtures/factories DRY; assert on contracts callers rely on.
