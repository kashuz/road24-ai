---
paths:
  - "**/Dockerfile"
  - "**/Dockerfile.*"
  - "**/docker-compose*.yml"
  - "**/docker-compose*.yaml"
  - "deploy/**"
  - "k8s/**"
  - "helm/**"
  - "**/*.tf"
description: Infra/DevOps conventions — Docker, docker-compose, Kubernetes/Helm, Terraform.
---

# Infra / DevOps conventions

## Containers
- Multi-stage builds; pinned, minimal base images; non-root user; deps-before-source layer order; `.dockerignore`.
- Healthcheck + EXPOSE. Never `COPY` secrets/`.env`/keys into an image — secrets via env at runtime.
- Keep dev/prod compose overlays consistent; don't fix one and break another.

## Kubernetes / Helm (manifests repo)
- Always set resource requests/limits + readiness/liveness probes — no unbounded pods.
- Non-root, read-only FS where feasible; secrets via Secret/external store (never plaintext); sane RBAC.
- Rolling updates tuned for zero downtime; HPA where load varies; TLS via cert-manager + ingress-nginx.

## CI/CD
- Lint + typecheck + tests gate merges; build/push to GHCR (org kashuz); pin action SHAs; least-privilege
  `GITHUB_TOKEN` (`packages: write` only on the push job); no secrets in logs.

## Always
- Pin versions (reproducible). Validate before applying (`docker build`, `docker compose config`,
  `kubectl apply --dry-run`, `helm lint`). Changes must be safe to roll back.

> Deep rulebook: `skills/road24-conventions/references/{security,clean-code}.md`.
> Skills: `dockerize-service`, `new-ci-pipeline`, `new-k8s-manifest`.
