---
name: cross-service-contract
description: Keep a Road24 API contract in sync across producer and consumers when an endpoint/schema changes — backend (FastAPI/DRF/Nest) ↔ clients (React/Svelte/Vue/Flutter/RN) and service↔service. Use for "I changed the X response, update the consumers", "add field Y end-to-end", "this client type drifted from the API".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[the endpoint/field that changed] [producer repo]"
---

# Sync a Cross-Service Contract

Contract change: $ARGUMENTS

The Road24 shared contract: **camelCase** JSON fields, `{code, message, details}` error envelope,
`?page=&limit=` pagination, JWT (Bearer). A change on one side must propagate to every consumer.

## Steps

1. **Identify producer + consumers.** From `knowledge/platform-map.md`: who serves this endpoint
   (backend / insurance / bff / gateway / nest) and who consumes it (which clients + which services).
   `grep` the path/field across repos to find every call site:
   ```bash
   grep -rn "v1/holds" ~/work/road24-dashboard ~/work/road24-web ~/work/road24-mobile ...
   ```
2. **Producer side** — update the schema/serializer/DTO + docs (Pydantic / DRF serializer /
   class-validator + Swagger). Keep camelCase aliases and the error envelope. Version the endpoint if
   the change is breaking.
3. **Consumer side** — update the typed API models in each client to match exactly:
   - React/RN: the `api/` DTO types (+ zod schema where used, e.g. alimony)
   - Svelte (road24-web): the TS types + `load`/endpoint code
   - Vue (new-webview): the API-layer types
   - Flutter: the `freezed` model `fromJson` (re-run build_runner)
4. **Backward compatibility** — additive fields are safe; removals/renames need expand→migrate→
   contract (serve both, switch consumers, then drop). Don't break a deployed client.
5. **Verify** — typecheck/tests on every touched repo; for Flutter re-run codegen.

## Rules

- The producer schema is the source of truth — clients model it, never guess the wire shape.
- camelCase on the wire; map to each language's idiom inside the client.
- Honor the `{code,message,details}` envelope on the consumer side (onto form fields where relevant).
- List every consumer you updated (and any you intentionally left for a follow-up) so nothing drifts.
- For non-additive changes, coordinate with `backend-architect` + `frontend-architect` on rollout order.
