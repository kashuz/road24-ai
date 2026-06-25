---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/*.ts"
description: React/TypeScript client conventions (dashboard, alimony, portofolio, webviews, RN, fortune).
---

# React/TypeScript conventions

Frontend is a **thin presentation layer** — business logic + authz live in the backend. The repo's
stack varies (dashboard = MUI/Redux/Formik/react-intl; others differ) — read `package.json` and an
existing feature first; never import a different stack's libs.

## Architecture (FSD)
- Organize by feature slice (`features/<x>/{api,model,ui}` + `index.ts`); import slices via `index.ts`
  only, higher layer → lower layer only — predictable dependencies, isolated features.
- Server state in React Query (where present); never duplicate it into Redux/Zustand — one source of truth.
- No `useEffect`-based fetching, no raw `fetch` — use the shared axios client (Bearer interceptor).

## Style
- Strict TS: no `any` (use `unknown`+narrowing/zod), no `!`, no `@ts-ignore`, no unchecked `as` — types
  are the contract; validate wire shapes at the boundary. Model every API DTO.
- i18n for all user-facing strings (react-intl or i18next per repo) — no hardcoded copy.
- Memoize hot renders; key lists; handle loading/empty/error states.

## Security
- No secrets in the client bundle; tokens in secure storage, not localStorage where avoidable.
- The client is not a trust boundary — never rely on client-side checks for authz.

## Tests
- Testing Library (vitest/jest): query by role/label, mock the API (MSW/axios), assert loading/empty/
  error + `{code,message,details}`→field mapping. Behavior, not internals.

> Deep rulebook: `skills/road24-conventions/references/{feature-sliced-design,clean-code,security,testing}.md`.
