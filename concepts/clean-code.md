# Clean Code — SOLID, DRY, KISS, YAGNI

Applies to every language in the suite. The layering ([clean-architecture.md](clean-architecture.md))
says *where* code goes; this says *how* it's written.

## SOLID

- **S — Single Responsibility:** a class/function/module has one reason to change. A service does one
  use case; a repository does data access; a component renders one thing.
- **O — Open/Closed:** extend via new code (new strategy/integration), not by editing tested logic.
  The NestJS multi-insurer gateway and the SDK integrations are this — add an implementation of the
  shared interface.
- **L — Liskov:** a subtype/implementation honors its interface's contract — no surprising overrides.
- **I — Interface Segregation:** small, focused interfaces (a repository per aggregate, not a god-repo).
- **D — Dependency Inversion:** depend on abstractions, inject them. Services depend on repository
  interfaces, not concrete ORM/HTTP. This is what makes the layers testable.

## DRY, KISS, YAGNI

- **DRY:** one source of truth for each rule/shape. **Search for an existing** service/repository/
  hook/component/type before writing a new one (the legacy backend has duplicates — don't add more).
  But don't over-DRY: two things that look alike but change for different reasons stay separate.
- **KISS:** the simplest thing that works and reads clearly. Prefer obvious code over clever code.
- **YAGNI:** build only what's asked. No speculative abstraction, config, or "future-proofing."

## Style rules (cross-stack)

- **Names** reveal intent: `confirm_policy`, not `do_it`/`handle2`. No abbreviations that aren't domain terms.
- **Small functions**, one level of abstraction each. Extract instead of nesting. Target < ~20 lines.
- **Guard clauses / early returns** over nested `if/else` pyramids.
- **No magic values** — named constants / `StrEnum` / `TextChoices` / TS unions.
- **Full types** everywhere. Python: 3.12 hints; TS: strict, no `any`/`!`/`@ts-ignore`/unchecked `as`
  (narrow or validate with zod/type guards at the boundary).
- **Logging, not prints:** `logger`/SDK, never `print`/`console.log` in shipped code; never log secrets/PII.
- **Comments** explain *why*, not *what*. Delete dead/commented-out code. No TODOs without a ticket.
- **Errors** are handled or propagated deliberately — never swallowed silently. Raise domain errors;
  map them at the boundary.
- **Immutability** by default (frozen DTOs, freezed models, `const`); avoid shared mutable state.
- **Pure where possible:** isolate side effects (I/O) in repositories/effects; keep logic pure & testable.

## Hard rules (the reviewer enforces these)

1. No duplicated logic that should be one function/service; reuse before adding.
2. No `any`/`!`/`@ts-ignore` in TS; no untyped Python; no magic strings/numbers.
3. Guard clauses over deep nesting; functions small and single-purpose.
4. No `print`/`console.log`, no dead code, no swallowed errors, no secrets in logs.
5. Inject dependencies (supports SOLID-D + testing); don't instantiate collaborators inside logic.
6. YAGNI — no unrequested features or premature abstraction.

When a repo's `.claude/concepts/clean-code.md` exists (e.g. road24-backend), it refines these — follow it.
