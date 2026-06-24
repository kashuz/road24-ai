---
name: new-react-hook
description: Scaffold a React Query data hook (query or mutation) for a Road24 React client — typed, with centralized query keys, cache invalidation, and error-envelope handling. Use for "a hook to fetch X", "a mutation for Y", "wire Z to the API".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[repo] [query|mutation] [resource]"
---

# Create a React Query Hook

Hook for: $ARGUMENTS

For repos using `@tanstack/react-query` (dashboard, webviews host, R24Native, …). Server state lives
in React Query — not Redux/Zustand. Hooks wrap the typed API layer (see `new-api-client`).

## Steps

1. **Read first** — the repo's `api/` layer, existing hooks, and the query-key convention. Match them.
2. Query → `useQuery` with a centralized key. Mutation → `useMutation` + invalidate affected queries.
3. Type inputs/outputs from the API DTOs; surface the `{code,message,details}` envelope to callers.

## Query

```ts
import { useQuery } from '@tanstack/react-query';
import { getHold, holdKeys } from '../api/holds';

export const useHold = (id: number) =>
  useQuery({ queryKey: holdKeys.detail(id), queryFn: () => getHold(id), enabled: id > 0 });
```

## Mutation (with invalidation)

```ts
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createHold, holdKeys } from '../api/holds';

export const useCreateHold = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: createHold,
    onSuccess: () => qc.invalidateQueries({ queryKey: holdKeys.all }),
  });
};
```

## Rules

- Centralize query keys per feature (`holdKeys`), never inline string arrays. Type everything.
- Don't copy server data into Redux/Zustand — read it from the query cache.
- Invalidate (or optimistically update) the right keys after mutations. Set `enabled` to avoid bad fetches.
- Let the error envelope propagate so forms can map it onto fields; don't swallow errors in the hook.
- For repos without React Query (alimony/portofolio), use the repo's existing data pattern instead.
