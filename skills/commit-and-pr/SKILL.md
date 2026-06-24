---
name: commit-and-pr
description: Commit and open a PR following Road24 conventions — RDFT-/SUG- ticket branch naming, conventional-commit messages, lint/test gates, and a clear PR body. Use for "commit this", "open a PR", "prepare these changes for review".
user-invocable: true
allowed-tools: Read, Bash, Grep, Glob
argument-hint: "[ticket id, e.g. RDFT-4117] [short summary]"
---

# Commit & Open a PR (Road24)

Prepare and submit: $ARGUMENTS

Road24 repos (org **kashuz**) use ticket-scoped branches like `RDFT-<n>/<slug>` and `SUG-<n>/<slug>`
(e.g. `RDFT-4117/payment_rebuild`, `SUG-000/security_fix`). Follow the repo's existing style — check
`git log` / branch names first.

## Steps

1. **Pre-flight (don't commit broken code):**
   - `git status` + `git diff` — review every change; no stray debug/secret/`.env`/key files.
   - Run the repo's gates: lint + types + tests (`ruff`+`mypy`+`pytest` / `npm run lint`+`tsc`+test /
     `flutter analyze`+`flutter test`). Don't commit red.
2. **Branch** — if on `main`/`master`, create `TICKET/<slug>` from the ticket id. Never commit
   straight to the default branch.
3. **Commit** — conventional style, imperative, ticket-referenced:
   ```
   feat(insurance): add OSAGO hold confirmation endpoint [RDFT-4107]
   fix(web): stop leaking server key into client bundle [SUG-000]
   ```
   Small, focused commits. Body explains *why* when non-obvious.
4. **Push** `git push -u origin <branch>`.
5. **PR** via `gh pr create` — title mirrors the ticket; body covers Summary / Changes / Testing /
   Risks-rollback / linked ticket. Target the repo's integration branch (often `main`/`master` — confirm).

## PR body template

```
## Summary
<what + why, link the ticket>

## Changes
- <repo/layer>: <change>

## Testing
- <commands run + result>

## Risks / rollback
- <breaking? migration? how to revert>
```

## Rules

- Only commit/push when the user asked. Confirm before pushing or opening a PR (outward-facing).
- Never commit secrets/keys/`.env`. If you spot committed key material, stop and flag it (security-auditor).
- Keep the contract in sync if the diff changes an API (`cross-service-contract`).
- End commit messages and PR bodies with the repo's required trailers/format if it has any.
