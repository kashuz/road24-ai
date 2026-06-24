---
name: dockerize-service
description: Write or harden a Dockerfile + docker-compose for a Road24 service — multi-stage build, pinned/minimal base, non-root, layer caching, healthcheck, no baked secrets. Use for "dockerize X", "optimize this Dockerfile", "add compose for Y", "shrink the image".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[repo] [service]"
---

# Dockerize / Harden a Service

Containerize: $ARGUMENTS

Match the suite's existing patterns first — many repos have multiple Dockerfiles (e.g. api/worker)
and compose overlays (`.dev`/`.local`/`.prod`/`.ghcr`). Keep parity across them.

## Steps

1. **Read first** — the repo's existing `Dockerfile*`, `docker-compose*.yml`, `Makefile`, and how a
   sibling service is built. Detect the runtime (uv/Python, node/pnpm, etc.).
2. Multi-stage: builder (deps + build) → slim runtime (only what's needed). Order layers deps-first for cache.
3. Non-root user, healthcheck, `.dockerignore`, no secrets baked in (pass via env at runtime).
4. Validate: `docker build` and `docker compose config`; report image size before/after.

## FastAPI (uv) example

```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN pip install --no-cache-dir uv && uv sync --frozen --no-dev

FROM python:3.12-slim AS runtime
WORKDIR /app
RUN useradd -m -u 1000 app
COPY --from=builder /app/.venv /app/.venv
COPY . .
ENV PATH="/app/.venv/bin:$PATH"
USER app
HEALTHCHECK --interval=30s --timeout=3s CMD curl -fsS http://localhost:8000/health || exit 1
EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Node/React build (static) — sketch

`node:20-slim` builder → `nginx:alpine` runtime serving `dist/` (match the repo's nginx conf).

## Rules

- Pin base image tags; multi-stage to keep runtime lean. Non-root user; drop build tools from runtime.
- `.dockerignore` (node_modules, .venv, .git, tests, caches). Never `COPY` secrets/`.env`/keys into the image.
- Secrets/config via env at runtime (compose/k8s), not build args. Add a healthcheck + EXPOSE.
- Keep dev/prod compose overlays consistent; don't fix one and break another. Reuse the repo's Makefile targets.
