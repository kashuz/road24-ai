---
name: new-react-feature
description: Scaffold a feature module in a Road24 React/TypeScript app (dashboard, web, webviews, landing) — typed API layer, React Query hooks, components, forms, and route wiring with strict TS.
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[feature] [screen/queue/form] [description]"
---

# Build a React Feature Module

Build a feature for: $ARGUMENTS

Targets: `road24-dashboard`, `road24-web`, `road24-insurance-webview`, `new-webview`,
`tgbot-admin`, `road24-landing`, etc. The frontend is a **thin presentation layer** — no business
logic; consume the REST API and render state.

## Steps

1. **Read first** — `src/shared/` (axios client, ui primitives, types) and an existing
   `src/features/<x>/` module. Match its structure, query-key style, and error handling.
2. Confirm the API contract: camelCase fields, `{code, message, details}` error envelope,
   `?page=&limit=` pagination.
3. Build the folders below; wire the route; run `npm run lint` and `tsc --noEmit` / `npm test`.

## Folder layout (feature-based)

```
src/features/<feature>/
  api/         # axios calls + DTO types + query keys
  hooks/       # React Query hooks (useXQuery, useXMutation)
  components/  # presentational + container components
  pages/       # route entry
  index.ts     # public barrel
```

## API layer (typed)

```ts
import { apiClient } from '@/shared/api/client';

export interface Hold { id: number; status: string }
export const holdKeys = { all: ['holds'] as const, detail: (id: number) => ['holds', id] as const };

export const getHold = async (id: number): Promise<Hold> => {
  const { data } = await apiClient.get<Hold>(`/v1/holds/${id}`);
  return data;
};
```

## React Query hook

```ts
import { useQuery } from '@tanstack/react-query';

export const useHold = (id: number) =>
  useQuery({ queryKey: holdKeys.detail(id), queryFn: () => getHold(id) });
```

## Form (react-hook-form + error envelope)

```ts
const onSubmit = handleSubmit(async (values) => {
  try {
    await createHold(values);
  } catch (e) {
    const details = extractEnvelope(e)?.details ?? {};
    Object.entries(details).forEach(([field, msg]) => setError(field, { message: String(msg) }));
  }
});
```

## Rules

- **Server state → React Query only.** Zustand is for UI/session state (token, active visit) — never
  duplicate server data into it. No `useEffect`-based fetching, no raw `fetch`.
- **Strict TS:** no `any` (use `unknown` + narrowing), no `!`, no `@ts-ignore`, no unchecked `as`.
  Model every API DTO explicitly.
- **i18next** for all user-facing strings — nothing hardcoded. Tailwind + `clsx` for styling.
- Surface backend validation onto the matching form fields. Handle loading/empty/error states.
