---
name: new-nest-resource
description: Scaffold a NestJS resource (module + controller + service + DTOs + TypeORM repository) for nest-insurances, with class-validator DTOs and Swagger decorators.
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[resource] [method] [route] [description]"
---

# Create a New NestJS Resource (nest-insurances)

Create a resource/endpoint for: $ARGUMENTS

Architecture: **Controller → Service → Repository**. DTOs use `class-validator`; controllers carry
Swagger decorators; TypeORM for persistence; Redis cache via `cache-manager` where appropriate.

## Steps

1. **Read first** — an existing module/controller/service under `src/`, and the `package.json`
   scripts. Match the project's structure and DI style.
2. **Search** for an existing service/provider before adding one.
3. Build: entity (if new) → DTOs → repository/service → controller → wire into the module.
4. Run `npm run lint` and `npm test`.

## DTO (class-validator + Swagger)

```ts
import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsPositive } from 'class-validator';

export class CreateHoldDto {
  @ApiProperty()
  @IsInt()
  @IsPositive()
  amount: number;

  @ApiProperty()
  @IsInt()
  vehicleId: number;
}
```

## Service (business logic, injectable)

```ts
import { Injectable } from '@nestjs/common';

@Injectable()
export class HoldsService {
  constructor(private readonly holdsRepository: HoldsRepository) {}

  async create(dto: CreateHoldDto): Promise<HoldResponseDto> {
    const hold = await this.holdsRepository.createHold(dto);
    return { id: hold.id, status: hold.status };
  }
}
```

## Controller (thin)

```ts
import { Body, Controller, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('holds')
@Controller('v1/holds')
export class HoldsController {
  constructor(private readonly holdsService: HoldsService) {}

  @Post()
  create(@Body() dto: CreateHoldDto): Promise<HoldResponseDto> {
    return this.holdsService.create(dto);
  }
}
```

## Rules

- Controllers stay thin — validation via DTO pipes, then call the service. No logic in controllers.
- Every DTO field is validated (`class-validator`) and documented (`@ApiProperty`).
- Inject dependencies via the constructor; register providers in the module.
- Strict TypeScript — no `any`. Handle errors with Nest exceptions, not thrown strings.
- Add jest unit tests (service with mocked repository) and update e2e if the contract changed.
