# Misc frontends

Smaller Road24 web clients + a starter template. All TypeScript/JS; use `react-engineer` (or
`vue-engineer` for new-webview), reading each repo's `package.json` first.

## road24_alimony_web
- **Repo:** kashuz/road24_alimony_web · Alimony web app. React + TS + Vite, react-router-dom,
  **i18next**, **zod**, axios. Branch: `main`. No `.claude/`.
- Conventions: react-router routes; zod for runtime validation/parsing of API data (use it at the API
  boundary instead of unchecked casts); i18next for copy. Strict TS. `npm run dev|build` · eslint.

## portofolio
- **Repo:** name `portoflio_company` · Company portfolio site. React + TS + Vite, **Redux Toolkit**,
  i18next, vite-plugin-svgr, axios. No `.claude/`.
- Mostly presentational + content; Redux for any shared UI state, i18next for copy. `npm run dev|build`.

## fortune / fortuneplanet
- **Next.js** + TS marketing sites (`fortune` package name is also `fortuneplanet`; treat as the same
  product's site). next-sitemap, postcss. Use Next conventions (app/pages router — check), SSR/SSG,
  SEO. `npm run dev|build|start`. No `.claude/`.

## new-webview
- **Repo:** kashuz/new-webview · **Vue 3** + Vite insurance webview (`<script setup>`). Has both
  `vite.config.js` and `vue.config.js` — confirm the active build. Branch: `SUG-001`. No `.claude/`.
- Use **`vue-engineer`**. Composition API, Pinia (if present), strict TS, webview/host-bridge aware.

## frontend
- **Not an app** — only `docker/` + `kubernetes/` deploy configs. Infrastructure/deploy assets for a
  frontend. Treat with `devops`, not an engineer.

## template_project
- React + Vite **FSD boilerplate/starter** (feature-sliced design). Includes Cypress (e2e),
  json-server (mock API), webpack config, i18n. Use as a reference/starting point for new React apps —
  not a deployed product. `yarn dev` · `cypress` · `tsc`.

## Shared notes
- All consume the Road24 REST API: camelCase, `{code,message,details}` envelope, `?page=&limit=`.
- These are good `bootstrap-claude-project` candidates (none have `.claude/` except via the hub).
