# road24-web

**Main Road24 web app.** Full-stack **SvelteKit** — it has a server side (DB access, PDF generation,
proxying to backend services), not just a SPA.

- **Repo:** kashuz/road24-web · **Stack:** SvelteKit + TypeScript, `@sentry/sveltekit`, axios
  (+ axios-retry, axios-cookiejar-support, https-proxy-agent), **knex + pg** (server DB),
  `prom-client` (metrics), `pdf-lib`, `node-telegram-bot-api`, simple-git-hooks. Branch:
  `SUG-000/security_fix`. **Has `.claude/`:** no (candidate for bootstrap).

## Architecture (SvelteKit)
- Routes in `src/routes/` — `+page.svelte` (UI), `+page.server.ts` / universal `+page.ts` (`load`),
  `+server.ts` (API endpoints), form actions for mutations.
- **Server-only** code (knex/pg, secrets, proxy) lives in `$lib/server` / `*.server.ts` / `+server.ts`
  — must never reach the client bundle.
- Sentry for errors, prom-client for metrics, axios (with retry + cookie jar + proxy) to upstreams.

## Commands
```bash
npm run dev | build | preview
npm run check       # svelte-check (typecheck)
npm run lint ; npm run format
npm run redis-build # project-specific
```
Multiple compose overlays: `docker-compose.yml`, `.dev.yml`, `.local.yml` (+ `Dockerfile`, `Dockerfile.dev`).

## Conventions & gotchas
- Keep DB/secret access strictly server-side. Strict TS — no `any`/`!`. Type DTOs; honor the error envelope.
- Stores/runes for reactive state; don't duplicate server data into client stores.
- Note: `encoded-key.txt` exists in the tree — treat any committed key material as a finding for
  `security-auditor`; never echo secrets.
