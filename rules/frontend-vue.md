---
paths:
  - "**/*.vue"
description: Vue 3 conventions for new-webview (insurance webview, script-setup SFCs).
---

# Vue 3 conventions (new-webview)

Vue 3 + Vite insurance webview. Thin presentation layer — consume the API, render state. FSD slices
(`features/<x>/{api,model,ui}`).

## Architecture
- `<script setup lang="ts">` + Composition API only (no Options API in new code) — consistent, typed.
- Server state via composables/API layer; client/session state via Pinia (if present) — never
  duplicate server data into the store.
- Respect FSD import direction; import slices via `index.ts`.

## Style
- Strict TS: no `any`/`!`/`@ts-ignore`. Type `defineProps`/`defineEmits` explicitly; type API DTOs.
- Honor the `{code,message,details}` envelope → onto form fields. Localize strings; handle loading/empty/error.

## Security
- No secrets in client code; webview-aware (host bridge, cookies, deep-link params handled as the repo does).

## Tests / verify
- `npm run lint` + `npm run build` pass before "done".

> Deep rulebook: `skills/road24-conventions/references/{feature-sliced-design,clean-code,security}.md`.
