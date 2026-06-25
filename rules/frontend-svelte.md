---
paths:
  - "**/*.svelte"
  - "src/routes/**"
  - "src/lib/**"
description: SvelteKit conventions for road24-web (full-stack: knex/pg, axios, PDF, Sentry).
---

# SvelteKit conventions (road24-web)

Full-stack SvelteKit (JS-leaning, jsconfig). Routes drive pages; FSD shared/entities/features live
under `src/lib`.

## Architecture
- Use the right primitive: `load` (`+page.(server.)js`) for reads, form actions for mutations,
  `+server.js` for JSON endpoints — don't fetch in components.
- Reactive state via stores/runes; don't duplicate server data into client stores — one source of truth.

## Security (critical here)
- Server-only code (knex/pg, secrets, proxy) stays server-side — `$lib/server`, `*.server.js`,
  `+server.js`. Never import it into a client component or it ships in the bundle.
- Treat any committed key material as a finding (this repo has had some); never echo secrets.

## Style
- Type/validate the wire shape at the boundary (JS: no compile-time types to lean on). Honor the
  `{code,message,details}` envelope → surface onto the form. Sentry context on errors.
- Localize user strings; semantic, accessible, labelled markup.

## Tests / verify
- `npm run check` (svelte-check) + `npm run lint` must pass before "done".

> Deep rulebook: `skills/road24-conventions/references/{feature-sliced-design,clean-code,security}.md`.
