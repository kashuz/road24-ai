# nest-insurances

**Universal insurance-services gateway** (Шлюз страховых сервисов) — one interface over multiple
external insurance-company APIs, simplifying integration, management, and processing of insurance ops.

- **Repo:** kashuz/nest-insurances · **Stack:** NestJS, TypeScript, TypeORM (pg), class-validator,
  `@nestjs/swagger`, cache-manager (Redis), `@nestjs/microservices`, axios. Branch: `main`.
- **Has `.claude/`:** no (candidate for `bootstrap-claude-project`).

## Architecture
`Controller → Service → Repository`. DTOs validated with `class-validator`, documented with Swagger
(`@ApiProperty`). TypeORM entities/repositories for persistence. Per-insurer integrations behind a
shared abstraction.

## Structure
`src/` (modules/controllers/services/dtos/entities) · `test/` · `nest-cli.json` ·
`tsconfig*.json`. Standard Nest module layout.

## Commands
```bash
npm run start:dev          # watch
npm run lint               # eslint --fix
npm test ; npm run test:cov ; npm run test:e2e
nest build
```

## Conventions
- Thin controllers (DTO validation pipe → service). Strict TS, no `any`. Nest exceptions for errors.
- Cache external responses via cache-manager/Redis where it reduces upstream calls.
- New insurer integration → extend the common interface, don't duplicate handling logic.

## Skill
`new-nest-resource`.

## Relationship to the suite
Overlaps in domain with `road24-insurance` (OSAGO) but is the **NestJS** multi-insurer gateway —
different stack and scope. Confirm which service owns a given insurer integration before adding it.
