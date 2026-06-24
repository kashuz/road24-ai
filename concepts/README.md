# Architecture Concepts — the shared rulebook

The non-negotiable principles every Road24 hub agent follows. These are **stack-agnostic rules**;
the per-stack application lives in the engineer agents, the skills, and each repo's own
`.claude/concepts/*` (which take precedence when they're more specific).

> **Mandate:** every agent reads the concepts relevant to its work in its "Step 0 — Orient" and
> **obeys them**. The per-language reviewers and `security-auditor` enforce them — a change that violates a
> concept is a finding. When a repo's own `.claude/concepts/*` conflicts, the **repo's** rule wins
> (it's more specific); otherwise these apply.

## The concepts

| File | Applies to | In one line |
|------|------------|-------------|
| [clean-architecture.md](clean-architecture.md) | all backends + Flutter | Dependency rule + layering: boundary → service → repository; logic never in the boundary |
| [feature-sliced-design.md](feature-sliced-design.md) | all frontends (React/Svelte/Vue/RN) | Layered feature slices with a strict one-way import rule |
| [clean-code.md](clean-code.md) | everything | SOLID, DRY, KISS, YAGNI, naming, small functions, guard clauses |
| [security.md](security.md) | everything (payments/PII platform) | AuthZ/IDOR, injection, secrets/PII, validation, idempotency |
| [testing.md](testing.md) | everything | AAA, behavior over implementation, mock at boundaries, determinism |

## Precedence (most specific wins)

1. The repo's own `.claude/concepts/*` and `CLAUDE.md`
2. The relevant `knowledge/projects/<repo>.md`
3. These hub concepts
4. General language/framework idiom

If two rules genuinely conflict and none is more specific, prefer the **safer, simpler, more
testable** option and note the trade-off.
