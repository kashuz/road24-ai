---
name: new-svelte-feature
description: Scaffold a SvelteKit route/feature in road24-web — +page.svelte (UI), +page.server (load/actions) or +server endpoint, components, and stores, keeping server-only code (knex/pg, secrets) server-side. Use for "add the X page to road24-web", "a server load/action for Y", "an API endpoint for Z".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[route/feature] [page|endpoint|action] [description]"
---

# Build a SvelteKit Feature (road24-web)

Build a feature for: $ARGUMENTS

Target: `road24-web` (SvelteKit, full-stack — server side has knex/pg, axios to backend services,
PDF generation, prom-client, Sentry). Note this repo is **JS-leaning** (jsconfig). Follow FSD where it
fits (`skills/road24-conventions/references/feature-sliced-design.md`, SvelteKit mapping): routes drive `pages`; shared/entities/
features live under `src/lib`.

## Steps

1. **Read first** — existing routes under `src/routes/` (`+page.svelte`, `+page.server.*`, `+server.*`),
   `src/lib` (shared client/stores, axios setup), and how server-only access is isolated. Match them.
2. Decide the shape: **page** (`+page.svelte` + `load`), **mutation** (form action in `+page.server`),
   or **endpoint** (`+server` JSON). Put data access in the server module.
3. `npm run check` (svelte-check) + `npm run lint`.

## Page + server load

```js
// src/routes/holds/[id]/+page.server.js  — runs on the server only
import { getHold } from '$lib/server/holds';        // knex/pg or axios — server-only

export async function load({ params }) {
  const hold = await getHold(Number(params.id));
  return { hold };
}
```

```svelte
<!-- src/routes/holds/[id]/+page.svelte -->
<script>
  export let data;            // { hold } from load
</script>

{#if data.hold}
  <HoldCard hold={data.hold} />
{/if}
```

## Form action (mutation)

```js
// +page.server.js
export const actions = {
  confirm: async ({ request, params }) => {
    const form = await request.formData();
    try {
      await confirmHold(Number(params.id), form.get('otp'));
      return { success: true };
    } catch (e) {
      return fail(400, { code: e.code, message: e.message });   // {code,message,details} envelope
    }
  },
};
```

## Rules

- **Server-only code (knex/pg, secrets, proxy) stays server-side** — in `$lib/server`, `+page.server.*`,
  or `+server.*`. Never import it into a client component or leak it to the bundle. (This repo has
  flagged committed key material — never echo secrets; treat any in source as a security finding.)
- Use the right primitive: `load` for reads, form actions for mutations, `+server` for JSON APIs.
- Type DTOs (JS: validate the wire shape at runtime — no compile-time types to lean on). Honor the
  `{code,message,details}` envelope → surface onto the form. Sentry context on errors.
- Reactive state via Svelte stores/runes; don't duplicate server data into client stores. Localize
  user strings; semantic, accessible markup.
