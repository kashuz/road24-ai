# Feature-Sliced Design (FSD)

The frontend architecture for the Road24 clients (React, Svelte, Vue, React Native). FSD organizes
code by **business feature** in layers with a **strict one-way import rule**, so dependencies stay
predictable and features stay isolated. (Reference: feature-sliced.design.)

> Adoption varies across the fleet — `template_project` is full FSD; dashboard/others use feature
> folders. **Follow the repo's existing structure**, but when you add or restructure code, move it
> toward FSD. Don't half-migrate a repo without saying so.

## Layers (top imports from below, never upward)

```
app        → providers, router, global styles, store wiring (the composition root)
processes  → (optional) cross-page flows (e.g. multi-step onboarding)
pages      → route screens; compose widgets + features (Next.js: route entries)
widgets    → self-contained UI blocks (a sidebar, a visit card) composed of features/entities
features   → a user action with business value (createHold, confirmPolicy)
entities   → business entities (vehicle, policy, user): model + api + UI
shared      → reusable, business-agnostic: ui kit, axios client, lib, config, types
```

**Import rule:** a module may only import from layers **strictly below** it. `entities` may not
import `features`; `features` may not import `pages`; nothing imports `app`. `shared` imports nothing
from above. This rule is the whole point — it prevents tangled dependencies.

## Slices and segments

- **Slice** = a business domain inside a layer (`features/create-hold`, `entities/policy`). Slices in
  the same layer must **not** import each other directly — compose them one layer up.
- **Segment** = the standard split inside a slice:
  ```
  features/create-hold/
    ui/        # components
    model/     # state, hooks/stores, logic (React Query keys, zustand/redux slice, bloc-equivalent)
    api/       # typed calls + DTO types (see skill: new-api-client)
    lib/       # local helpers
    index.ts   # public API (barrel) — the ONLY thing other code imports
  ```
- **Public API:** import a slice through its `index.ts` only; never reach into its internals.

## Per-stack mapping

| Stack | Notes |
|-------|-------|
| React (dashboard, alimony, portofolio, webviews, RN) | `src/{app,pages,widgets,features,entities,shared}`; model segment holds React Query hooks + the repo's store (Redux/zustand) |
| SvelteKit (road24-web) | routes drive `pages`; keep `shared`/`entities`/`features` in `src/lib`; server-only code stays in `*.server.ts` |
| Vue (new-webview) | same layers; `model` uses composables/Pinia |
| Next.js (fortune) | `app/` or `pages/` is the routing layer; FSD lives under `src/` |

## Hard rules (the per-language reviewers enforce these)

1. Respect the import direction — higher layer → lower layer only. No upward or sideways (same-layer
   slice→slice) imports.
2. Import slices via their public `index.ts`; no deep imports into another slice's `ui/model/api`.
3. Business-agnostic, reusable code → `shared`; business entities → `entities`; user actions →
   `features`. Don't dump everything in `shared`.
4. Server state stays in the data layer (React Query / loaders), not duplicated into the UI store —
   see [clean-architecture.md](clean-architecture.md) (the frontend is a thin presentation layer).
5. Keep transport/types in `api/` segments (use `new-api-client`); keep components dumb where possible.

## Why

Predictable dependencies, features you can add/remove in isolation, and a consistent place for every
piece of UI/state/transport — the frontend equivalent of the backend's clean layering.
