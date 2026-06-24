# Security

Road24 handles payments, OSAGO insurance, and PII (passport/vehicle/financial data). Security is a
first-class rule for every agent, not a separate pass. The `security-auditor` audits deeply; **every**
engineer applies these as they write. See the `security-audit` skill for the full audit checklist.

## Always-on rules

1. **AuthZ on every object access (no IDOR).** Never trust a client-supplied id — scope queries to the
   authenticated user/tenant. The boundary checks permissions; the repository filters by ownership.
2. **Validate all input at the boundary.** Pydantic / class-validator / serializer / zod. Reject
   unbounded or unexpected input; no mass assignment (whitelist fields).
3. **No injection.** Parameterized queries only — no string-built SQL, no ORM `.raw()` with input, no
   shell/template injection. Validate/allow-list any URL used in httpx/dio/axios calls (**SSRF**) —
   critical for gateway/bff/databank calls.
4. **Secrets & PII discipline.** Never hardcode secrets; never log secrets or PII (passport, plate,
   payment); never return them in responses/errors. Secrets come from env/secret stores. Mask when
   citing (`sk_live_****`). No `.env`/keys committed.
5. **Trust boundaries between services.** Validate JWTs properly (alg/exp/aud/iss, strong secret).
   Don't trust unverified `X-User-*` headers from gateway/bff downstream without verification.
6. **Idempotency & abuse-resistance on money/insurance flows.** Hold/confirm must be idempotent and
   replay-safe; guard against double-spend, negative amounts, and OTP brute-force (rate limit + lockout).
7. **Least privilege everywhere** — DB users, service tokens, CI tokens, container users, k8s RBAC.

## By layer / stack

- **Boundary:** authn + authz + validation happen here before any logic runs.
- **Django:** soft deletes (don't expose deleted rows), permission classes, `@transaction.atomic` for
  consistency, no logic-in-view leaking authz. Watch N+1 turning into data-exposure via over-fetching.
- **FastAPI:** auth dependencies (`get_auth_user`), Pydantic validation, careful httpx to internal
  services (SSRF/host allow-list), sanitize logged bodies (the SDK helps).
- **Frontend/webview/mobile:** secrets never in client bundles (road24-web: keep DB/secret access
  server-side only); tokens in secure storage (MMKV/secure cookie), not localStorage where avoidable;
  the client is **not** a trust boundary — never rely on client-side checks for authz.
- **DevOps:** no secrets in images/logs/pipelines; pinned non-root containers; TLS; tight CORS; k8s
  secrets via Secret/external store; minimal `GITHUB_TOKEN`/RBAC scopes.

## Hard rules (reviewer + security-auditor enforce)

- Every endpoint authenticates + authorizes the specific object touched (IDOR check).
- All external input validated; all queries parameterized; all outbound URLs allow-listed.
- Zero secrets/PII in code, logs, responses, images, or commits.
- Money/insurance operations are idempotent and rate-limited.

A finding here outranks style — flag and fix security issues in any code you touch.
