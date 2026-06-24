---
name: new-api-client
description: Scaffold a typed API layer for a Road24 client — axios calls + DTO types + query keys, honoring the shared contract (camelCase, {code,message,details} envelope, ?page=&limit=). Works for React/Svelte/Vue/RN. Use for "add the API layer for X", "type the Y endpoint on the client", "a service to call Z".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[repo] [resource/endpoint]"
---

# Create a Typed API Client Layer

API layer for: $ARGUMENTS

The contract is fixed: **camelCase** fields, `{code, message, details}` error envelope,
`?page=&limit=` pagination, JWT (Bearer). The client models the backend DTOs exactly — never guesses
the wire shape.

## Steps

1. **Read first** — the repo's shared axios client (base URL + Bearer interceptor) and an existing
   `api/` module. Match structure + error handling. For alimony, validate responses with **zod**.
2. Model the request/response DTO types from the producer schema (see `cross-service-contract`).
3. Add the call(s) + query keys (React Query repos). Keep one module per resource.

## Template (axios + types)

```ts
import { apiClient } from '@/shared/api/client';

export interface Hold { id: number; status: string; vehicleId: number }
export interface CreateHoldDto { amount: number; vehicleId: number }
export interface Paginated<T> { items: T[]; page: number; limit: number; total: number }

export const holdKeys = {
  all: ['holds'] as const,
  list: (page: number) => ['holds', { page }] as const,
  detail: (id: number) => ['holds', id] as const,
};

export const getHold = async (id: number): Promise<Hold> =>
  (await apiClient.get<Hold>(`/v1/holds/${id}`)).data;

export const listHolds = async (page = 1, limit = 20): Promise<Paginated<Hold>> =>
  (await apiClient.get<Paginated<Hold>>('/v1/holds', { params: { page, limit } })).data;

export const createHold = async (dto: CreateHoldDto): Promise<Hold> =>
  (await apiClient.post<Hold>('/v1/holds', dto)).data;
```

## Error envelope helper

```ts
export interface ApiError { code: string; message: string; details?: Record<string, string> }
export const extractEnvelope = (e: unknown): ApiError | undefined =>
  (e as { response?: { data?: ApiError } })?.response?.data;
```

## Rules

- Strict types model the backend DTO; camelCase on the wire. No `any`/unchecked `as` — narrow or use zod.
- Use the shared axios instance (Bearer + base URL) — don't create per-call clients or use raw `fetch`.
- One module per resource; export query keys alongside calls. Pagination via `?page=&limit=`.
- Keep this layer logic-free (just transport + types); components/hooks/stores consume it.
- Svelte (road24-web): same types, but call from `load`/`+server.ts`; keep secrets server-side.
