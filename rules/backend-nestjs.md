---
paths:
  - "**/*.ts"
description: NestJS conventions for nest-insurances (universal insurance-services gateway).
---

# NestJS conventions (nest-insurances)

Clean architecture: **Controller → Service → Repository**. (Install in nest-insurances; React repos use
`frontend-react` — both are `.ts`.)

## Architecture
- Controllers thin: DTO validation pipe → call the service. No business logic in controllers.
- Inject via constructor; register providers in the module. Per-insurer integrations extend a shared
  interface — extend, don't fork handling logic (Open/Closed).
- TypeORM entities/repositories for persistence; cache external responses via cache-manager/Redis where it helps.

## Style
- Strict TS — no `any`. Every DTO field validated (`class-validator`) and documented (`@ApiProperty`, Swagger).
- Use Nest exceptions, not thrown strings.

## Security
- Validate all input at the DTO; authorize object access (no IDOR); never leak secrets/PII to logs/responses.

## Tests
- `jest`: services with mocked providers (`Test.createTestingModule`), e2e with supertest; cover validation
  failures. `npm run lint` + `npm test` before "done".

> Deep rulebook: `skills/road24-conventions/references/{clean-architecture,clean-code,security,testing}.md`.
> Skills: `new-nest-resource`, `new-nest-test`.
