---
name: new-ci-pipeline
description: Scaffold or fix a GitHub Actions pipeline for a Road24 repo — lint + typecheck + test gates, build & push to GHCR, dependency caching, pinned actions, least-privilege token. Use for "add CI for X", "the workflow is failing", "build and push the image on tag".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[repo] [what the pipeline should do]"
---

# Create / Fix a CI Pipeline (GitHub Actions)

Pipeline for: $ARGUMENTS

Match the suite's conventions — repos push images to **GHCR** (`docker-compose.ghcr.yml` present in
several). Gate merges on lint + types + tests.

## Steps

1. **Read first** — existing workflows in `.github/workflows/`, the repo's real lint/test/build
   commands (from Makefile/package.json/pyproject), and how images are tagged.
2. Build a gate job (lint → typecheck → test) + a build/push job (on tag/main). Cache deps.
3. Pin actions to SHA/major; least-privilege `permissions`; secrets via repo/org secrets, never inline.
4. Validate the YAML and the command names against the repo.

## Skeleton

```yaml
name: ci
on:
  pull_request:
  push: { branches: [main, master] }
permissions: { contents: read }
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # --- Python (uv) service ---
      - uses: astral-sh/setup-uv@v5
      - run: uv sync --frozen
      - run: uv run ruff check src/ && uv run mypy src/
      - run: uv run pytest --cov=src
      # --- or Node client ---
      # - uses: actions/setup-node@v4 with: { node-version: 20, cache: 'npm' }
      # - run: npm ci && npm run lint && npx tsc --noEmit && npm test
  build-push:
    needs: check
    if: startsWith(github.ref, 'refs/tags/') || github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    permissions: { contents: read, packages: write }
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with: { registry: ghcr.io, username: ${{ github.actor }}, password: ${{ secrets.GITHUB_TOKEN }} }
      - uses: docker/build-push-action@v6
        with: { push: true, tags: ghcr.io/kashuz/${{ github.event.repository.name }}:${{ github.sha }} }
```

## Rules

- Use the repo's **real** commands (verify against its files) — don't assume.
- Lint + types + tests must pass before build/push. Cache deps (uv/npm) to keep it fast.
- Pin actions; minimal `permissions` per job (`packages: write` only on the push job). No secrets in logs/inline.
- Tag images consistently (sha + semver on tags). Keep parity with the repo's GHCR compose overlay.
