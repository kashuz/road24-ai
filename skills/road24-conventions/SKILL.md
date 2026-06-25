---
name: road24-conventions
description: >-
  The universal Road24 engineering conventions — the architecture rulebook (clean architecture,
  feature-sliced design, clean code/SOLID, security, testing) plus the shared API contract. Load this
  for ANY non-trivial implementation, refactor, or review in any Road24 repo, even if the user doesn't
  mention conventions. Preloaded into the engineering agents so subagents don't rediscover the rules.
user-invocable: true
allowed-tools: Read, Grep, Glob
---

# Road24 Conventions (universal)

The cross-cutting rules every Road24 repo follows, regardless of stack. Per-area coding conventions
auto-load from `rules/*` by file path; this skill is the **universal layer** (and the only one that
reaches subagents via their `skills:`). The deep "why" lives in `references/` — read the one that
applies before non-trivial work.

## The rulebook (references/)

| Read when… | File |
|------------|------|
| Building any backend / mobile data layer | `references/clean-architecture.md` |
| Building any frontend (React/Svelte/Vue/RN) | `references/feature-sliced-design.md` |
| Writing any code | `references/clean-code.md` |
| Touching auth, payments, PII, external calls | `references/security.md` |
| Writing or judging tests | `references/testing.md` |

> Precedence (most specific wins): a repo's own `.claude/rules` & `CLAUDE.md` → `knowledge/projects/<repo>.md`
> → these references → general idiom. A violation is a defect, not a style nit. The per-language
> reviewers and `security-auditor` enforce them.

## Always-true (memorize — these apply everywhere)

- **Clean layering.** Boundary (router/view/controller/widget) holds no business logic; logic →
  service (`execute()`); data access → repository. Cross boundaries with DTOs/schemas. Inject deps.
- **Frontend is a thin presentation layer.** Business logic/authz live in the backend. Server state in
  the data layer (React Query / loaders), never duplicated into UI state. Respect FSD import direction.
- **Clean code.** SOLID/DRY/KISS/YAGNI. Full types (no `any`/`!`/`@ts-ignore`; typed Python). Guard
  clauses, small functions, enums not magic strings, `logger` not `print`/`console.log`. Reuse before adding.
- **Security is always-on.** AuthZ on every object access (no IDOR), validate all input, parameterized
  queries only, allow-list outbound URLs (SSRF), zero secrets/PII in code/logs/responses/commits,
  idempotent money/insurance flows. A security finding outranks style.
- **Tests with the change.** AAA, behavior over implementation, mock at boundaries, deterministic,
  cover failure paths. Suite green before "done".

## Shared API contract (producer ↔ consumer)

camelCase JSON fields · `{code, message, details}` error envelope (surface onto form fields) ·
`?page=&limit=` pagination · JWT (Bearer) between services. The producer schema is the source of
truth; clients model it, never guess. Keep both sides in sync (skill: `cross-service-contract`).

## How to use
1. Identify the repo's stack (`knowledge/platform-map.md` + `knowledge/projects/<repo>.md`).
2. Read the `references/*` relevant to the work.
3. Apply them; if a repo-local rule is more specific, it wins. Note any deliberate deviation + why.
