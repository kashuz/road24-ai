---
name: new-nest-test
description: Scaffold jest tests for nest-insurances — unit tests for services with mocked repositories (Test.createTestingModule) and e2e tests for controllers. Use for "write tests for the X service", "test the Y endpoint", "raise coverage".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[service/controller to test]"
---

# Create NestJS Tests (nest-insurances)

Tests for: $ARGUMENTS

Unit-test services in isolation with mocked dependencies via `Test.createTestingModule`; e2e-test the
HTTP layer with supertest.

## Steps

1. **Read first** — existing `*.spec.ts` / `test/` files; copy the testing-module + mocking style.
2. Unit: provide the class under test + mocked providers (repositories, http). Assert behavior.
3. e2e: bootstrap the app/module, hit routes with supertest, assert status + body + validation errors.
4. Run `npm test` / `npm run test:cov` (unit) and `npm run test:e2e`.

## Unit test (service + mocked repo)

```ts
import { Test } from '@nestjs/testing';

describe('HoldsService', () => {
  let service: HoldsService;
  const repo = { createHold: jest.fn() };

  beforeEach(async () => {
    const moduleRef = await Test.createTestingModule({
      providers: [HoldsService, { provide: HoldsRepository, useValue: repo }],
    }).compile();
    service = moduleRef.get(HoldsService);
  });

  it('creates a hold', async () => {
    repo.createHold.mockResolvedValue({ id: 1, status: 'pending' });
    await expect(service.create({ amount: 100, vehicleId: 1 })).resolves.toEqual({ id: 1, status: 'pending' });
  });
});
```

## Rules

- Mock all external providers (repositories, http, cache); no real DB/network in unit tests.
- Cover validation failures and error mapping (Nest exceptions), not just the happy path.
- e2e asserts the contract: status codes, response shape, `class-validator` rejection of bad input.
- Deterministic, isolated; reset mocks between tests. Don't test framework internals.
