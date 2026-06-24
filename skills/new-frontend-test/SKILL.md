---
name: new-frontend-test
description: Scaffold frontend tests for a Road24 React client — vitest/jest + Testing Library for components/hooks, with the API layer mocked (MSW or mocked axios). Use for "write tests for the X component/hook", "test the Y form", "raise frontend coverage".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[repo] [component/hook to test]"
---

# Create Frontend Tests (React)

Tests for: $ARGUMENTS

Detect the runner first — `road24-dashboard` uses **vitest** (`vitest.config.ts`); others may use
jest. Use **Testing Library**; test behavior/roles, not internals; mock the API boundary.

## Steps

1. **Read first** — the repo's test setup (vitest/jest config, setup file, any MSW handlers) and an
   existing test. Match imports + render helpers (providers: React Query, Redux store, i18n, router).
2. Render with the needed providers; query by role/label; assert on what the user sees.
3. Mock the API (MSW preferred, or mock the axios module / React Query) — no real network.
4. Run the suite; report pass/fail + coverage.

## Component test

```tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

test('submits the hold form and shows success', async () => {
  render(<HoldForm />, { wrapper: AllProviders });        // QueryClient + store + i18n + router
  await userEvent.type(screen.getByLabelText(/amount/i), '100');
  await userEvent.click(screen.getByRole('button', { name: /confirm/i }));
  expect(await screen.findByText(/hold created/i)).toBeInTheDocument();
});
```

## Hook test (React Query)

```tsx
import { renderHook, waitFor } from '@testing-library/react';

test('useHold returns data', async () => {
  const { result } = renderHook(() => useHold(1), { wrapper: QueryWrapper });
  await waitFor(() => expect(result.current.isSuccess).toBe(true));
  expect(result.current.data?.id).toBe(1);
});
```

## Rules

- Query by accessible role/label/text — not test ids or class names. Test behavior, not implementation.
- Mock the API at the boundary (MSW/axios mock); assert loading/empty/error states + the error envelope.
- Wrap with the real providers the component needs; reset query cache/store between tests.
- Cover form validation surfacing (`{code,message,details}` → field errors). Deterministic, isolated.
