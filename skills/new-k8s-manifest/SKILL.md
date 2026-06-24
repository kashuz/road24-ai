---
name: new-k8s-manifest
description: Scaffold Kubernetes manifests for a Road24 service in the manifests repo — Deployment, Service, Ingress, ConfigMap/Secret refs, probes, resource limits, HPA. Use for "add k8s manifests for X", "expose Y via ingress", "set resources/autoscaling for Z".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[service-name] [image] [port]"
---

# Create Kubernetes Manifests (manifests repo)

Manifests for: $ARGUMENTS

Work in `~/work/manifests` (kashuz/manifests). It already holds RBAC, ingress-nginx, cert-manager,
configmaps, redis, mongodb, etc. — match the existing layout/conventions before adding.

## Steps

1. **Read first** — a sibling service's manifests, the ingress-nginx + cert-manager setup, and how
   secrets/configmaps are referenced. Copy the structure (namespace, labels, annotations).
2. Deployment (probes + resources + non-root) → Service → Ingress (TLS via cert-manager) → config/secret refs.
3. Add an HPA if load varies. Validate with `kubectl apply --dry-run=client` / `kubeval`.

## Deployment + Service

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: { name: road24-insurance, labels: { app: road24-insurance } }
spec:
  replicas: 2
  selector: { matchLabels: { app: road24-insurance } }
  template:
    metadata: { labels: { app: road24-insurance } }
    spec:
      securityContext: { runAsNonRoot: true, runAsUser: 1000 }
      containers:
        - name: app
          image: ghcr.io/kashuz/road24-insurance:latest
          ports: [{ containerPort: 8000 }]
          envFrom: [{ secretRef: { name: road24-insurance-secrets } }]
          readinessProbe: { httpGet: { path: /health, port: 8000 }, initialDelaySeconds: 5 }
          livenessProbe:  { httpGet: { path: /health, port: 8000 }, initialDelaySeconds: 15 }
          resources:
            requests: { cpu: 100m, memory: 256Mi }
            limits:   { cpu: 500m, memory: 512Mi }
---
apiVersion: v1
kind: Service
metadata: { name: road24-insurance }
spec:
  selector: { app: road24-insurance }
  ports: [{ port: 80, targetPort: 8000 }]
```

## Rules

- Always set resource requests/limits + readiness/liveness probes. Run as non-root; read-only FS where feasible.
- Secrets via `Secret`/external store referenced by `secretRef` — never plaintext in the manifest.
- TLS via cert-manager + ingress-nginx, matching the repo's existing ingress annotations.
- Rolling updates (surge/unavailable tuned) for zero downtime; add HPA where load varies.
- Validate before commit (`--dry-run`); keep labels/namespaces consistent with the rest of `manifests`.
