---
name: security-audit
description: Run a white-box security audit of a Road24 repo (or cross-service flow) against the suite's threat model — auth/JWT, IDOR, injection, SSRF, secrets/PII, payment & insurance logic — and produce an evidence-based, prioritized findings report.
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
argument-hint: "[repo-path or flow, e.g. 'road24-insurance' or 'gateway→insurance hold/confirm']"
---

# White-Box Security Audit

Audit: $ARGUMENTS

Read-only. Produce findings auditors would accept: real attack paths, code evidence, masked secrets.
For a deep multi-file pass, hand off to the `security-auditor` agent.

## Steps

1. **Map entry points & auth** — list routers/views/controllers/handlers; identify the auth model
   (JWT validation, permission classes, how gateway/bff identity is trusted downstream).
2. **Trace untrusted input → sink** — for each entry point, follow user-controlled data to a DB,
   shell, HTTP (httpx/dio/axios), file, or response sink.
3. **Run the checklist** below; confirm exploitability by reading the actual code path.
4. **Rate** by realistic impact × exploitability and write the report.

## Checklist

- **AuthN/Z** — JWT alg/exp/aud/iss checks, secret strength; IDOR (object access without ownership);
  missing/incorrect permissions; trusting unverified gateway/bff headers; privilege escalation.
- **Injection** — raw SQL / ORM `.raw()` / f-string queries; command/template injection; **SSRF** via
  user-controlled URLs in gateway/bff/databank calls.
- **Secrets & PII** — hardcoded secrets; secrets in logs/Sentry/responses; `.env` committed; passport
  / vehicle / payment data leaked in logs or error envelopes.
- **Input validation** — missing Pydantic/class-validator/serializer validation; mass assignment;
  unbounded input; unsafe deserialization.
- **Crypto/sessions** — weak hashing; predictable tokens/OTP; missing rotation; insecure cookies.
- **Transport/headers** — TLS enforcement; CORS scope; security headers.
- **Dependencies** — known-vuln packages in lockfiles (`uv`/`pip`/`npm`/`pub`).
- **CI/CD & IaC** — secrets in pipelines; overprivileged tokens; unpinned/root images; permissive
  k8s RBAC (`manifests`).
- **Business logic** — payment/insurance abuse: race conditions in hold/confirm, replay, negative
  amounts, OTP brute-force, idempotency gaps.

## Report format (per finding)

```
### [CRITICAL|HIGH|MEDIUM|LOW] Title
- Location: file:line  (mask secrets, e.g. sk_live_****)
- Attack path: who → how → what they gain
- Evidence: the exact code/config making it exploitable
- Impact: concrete
- Remediation: specific, minimal fix
- Confidence: high/medium/low (+ how to confirm)
```

End with a prioritized remediation list; separate confirmed-exploitable from defense-in-depth.
Never print a secret in full.
