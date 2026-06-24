# road24-insurance-webview  (repo: road24-webviews)

**Insurance micro-frontends** delivered as in-app webviews. A **pnpm monorepo** of multiple apps
(micro-frontend architecture).

- **Repo:** kashuz/road24-webviews · **Stack:** pnpm workspace, Vite, TypeScript, MFE. Branch:
  `RDFT-4162/fix-alimony-start-page`.
- **Has `.claude/`:** yes — CLAUDE.md + CONTEXT.md + a rich agent set (appsec-auditor,
  architecture-mentor, compliance-gatekeeper, dependency-cve-auditor, developer, optimizer,
  secops-orchestrator, software-engineer, tester). This repo is the most security-instrumented client.

## Layout
- `pnpm-workspace.yaml` + `apps/`:
  - `apps/host` — the host/shell that loads remotes
  - `apps/scoring-validator` — a remote/MFE
- `Dockerfile.mfe`, `docker-compose.yml`, `nginx-dev`, `scripts/`, `prettier/`. pre-commit via `.hooks/`.

## Conventions
- **Module Federation / MFE** — respect host ↔ remote boundaries and the shared dependency contract;
  don't bundle a remote's deps into the host or vice-versa.
- Read the repo's own `.claude/CLAUDE.md` + `CONTEXT.md` first — they're detailed and authoritative.
- Webview concerns: host bridge, cookies, deep-link/start-page params (note the current branch is an
  alimony start-page fix). Mobile-first; strict TS.
- Security is first-class here (appsec-auditor, dependency-cve-auditor, compliance-gatekeeper agents) —
  keep that bar: no secrets in client code, validate input, watch CVEs in the lockfile.

## Commands
```bash
pnpm install
pnpm --filter host dev          # run a single app
pnpm -r build ; pnpm -r lint    # all workspaces
```
(Confirm exact scripts in each app's package.json.)
