# road24-dashboard

**Internal admin dashboard** for the Road24 platform (ops/admin views, charts, management).

- **Repo:** kashuz/road24-dashboard · **Stack:** React + TypeScript, **MUI** (`@mui/material` + lab +
  icons, emotion), **Redux Toolkit**, **React Query** (`@tanstack/react-query`), **Formik**,
  **react-intl** (i18n), `apexcharts`/`chart.js`, axios, clsx, Vite, **vitest**. Branch: `main`.
- **Has `.claude/`:** yes — CLAUDE.md + agents (architechture-mentor, patterns-mentor, tester).

## Stack specifics (do NOT assume the new-vision/Tailwind stack here)
- **Forms:** Formik (not react-hook-form). **i18n:** react-intl (`<FormattedMessage>` / `useIntl`),
  not i18next. **UI:** MUI components + emotion styling, not Tailwind.
- **State:** Redux Toolkit for app/UI state; React Query for server state — don't duplicate server
  data into Redux. **Charts:** apexcharts + chart.js.

## Commands
```bash
# package manager: yarn.lock + package-lock present — check which is canonical
yarn dev | build | preview      # or npm run …
npm run lint                    # eslint
npx vitest                      # tests (vitest.config.ts)
tsc --noEmit
```
Dockerized (Dockerfile + nginx + docker-entrypoint.sh) for deploy.

## Conventions
- Strict TS; model API DTOs; honor `{code,message,details}` envelope → surface onto Formik fields.
- Reuse MUI theme + shared components; keep feature folders consistent with the existing structure.

## Skill
`new-react-feature` (adapt: Formik instead of RHF, react-intl instead of i18next, MUI instead of Tailwind).
