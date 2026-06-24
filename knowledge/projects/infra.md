# Road24 infra repos

Deployment/infrastructure assets — work via the `devops` agent, not an engineer.

## manifests
- **Repo:** kashuz/manifests · Kubernetes deploy manifests for the platform. Branch: `master`.
- Contents: `RBAC/` · `ingress-nginx/` · `cert-manager/` · `configmaps/` · `cronjobs/` ·
  `custom_exporters/` · `db-balancer/` · `kubernetes-dashboard/` · `metabase/` · `mongodb/` ·
  `redis/`. README documents apply commands (e.g. redis updates).
- Conventions: resource requests/limits, probes, non-root, secrets via Secret/external store (never
  plaintext), sane RBAC, rolling updates. Validate with `kubectl apply --dry-run`, `kubeval`/`helm lint`.
- This is where the FastAPI/Django services and clients get deployed; cross-reference a service's
  Dockerfile + compose overlays when changing its manifest.

## deep-links
- **Repo:** kashuz/deep-links · Static **deep-link host** — nginx serving `html/` (apple-app-site-
  association / assetlinks-style universal-link files + landing). Branch: `main`.
- Contents: `Dockerfile` · `nginx.conf` · `html/`. No app logic.
- Conventions: keep the well-known link files correct (iOS/Android app association); nginx caching/headers.

## frontend (deploy configs)
- See `misc-frontends.md` — `frontend/` holds only `docker/` + `kubernetes/` deploy assets, no app.
