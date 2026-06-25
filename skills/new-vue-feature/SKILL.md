---
name: new-vue-feature
description: Scaffold a Vue 3 feature in new-webview — script-setup SFC components, a composable for data/logic, the typed API layer, store (Pinia) wiring, and a router view. Use for "add the X view/screen to new-webview", "a Vue component/composable for Y", "wire Z to the API".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[feature] [view/form] [description]"
---

# Build a Vue 3 Feature (new-webview)

Build a feature for: $ARGUMENTS

Target: `new-webview` (Vue 3 + Vite, `<script setup lang="ts">` SFCs). Frontend is a **thin
presentation layer** — consume the REST API and render state. Organize by feature per FSD
(`skills/road24-conventions/references/feature-sliced-design.md`, Vue mapping).

## Steps

1. **Read first** — `src/` existing SFCs, the router, the axios/API layer, and the store
   (Pinia/Vuex — check which). Match the established patterns. Confirm `vite.config.js` vs
   `vue.config.js` is the active build.
2. Build the slice: API layer (`new-api-client`) → composable (`model`) → presentational + container
   components (`ui`) → register the route. Keep webview/host-bridge + deep-link params as the repo does.
3. `npm run lint` and `npm run build`.

## Folder layout (FSD, Vue)

```
src/features/<feature>/
  api/        # axios calls + DTO types (see new-api-client)
  model/      # composables (useX), Pinia store slice if needed
  ui/         # .vue components (script setup)
  index.ts    # public barrel — the only entry other code imports
```

## Composable (model)

```ts
import { ref } from 'vue';
import { getHold, type Hold } from '../api/holds';

export function useHold(id: number) {
  const hold = ref<Hold | null>(null);
  const loading = ref(false);
  const error = ref<string | null>(null);

  async function load() {
    loading.value = true;
    error.value = null;
    try {
      hold.value = await getHold(id);
    } catch (e) {
      error.value = extractEnvelope(e)?.message ?? 'error';
    } finally {
      loading.value = false;
    }
  }
  return { hold, loading, error, load };
}
```

## Component (script setup SFC)

```vue
<script setup lang="ts">
import { onMounted } from 'vue';
import { useHold } from '../model/useHold';

const props = defineProps<{ id: number }>();
const { hold, loading, error, load } = useHold(props.id);
onMounted(load);
</script>

<template>
  <p v-if="loading">…</p>
  <p v-else-if="error">{{ error }}</p>
  <HoldCard v-else-if="hold" :hold="hold" />
</template>
```

## Rules

- `<script setup lang="ts">` + Composition API only (no Options API in new code). Strict TS — no
  `any`/`!`/`@ts-ignore`. Type `defineProps`/`defineEmits` explicitly.
- Server state through composables/API layer; client/session state via Pinia — never duplicate server
  data into the store. Honor the `{code,message,details}` envelope → surface onto form fields.
- Localize user-facing strings; handle loading/empty/error states. Respect the FSD import direction
  (import slices via `index.ts`; no upward/sideways imports).
- Webview-aware: host bridge, cookies, deep-link/start-page params handled as the repo already does.
