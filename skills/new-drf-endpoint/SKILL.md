---
name: new-drf-endpoint
description: Scaffold a thin Django/DRF endpoint (view + serializer + DTO + service + url) for road24-backend, keeping all logic out of the view/serializer.
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[app] [mobile|internal] [method] [path] [description]"
---

# Create a New DRF Endpoint (road24-backend)

Create an endpoint for: $ARGUMENTS

Architecture: **View → Serializer → DTO → Service → Repository**. Views and serializers are thin —
**no business logic, no ORM/external calls** there. DTOs are `@dataclass` in the app's `dto/` package.

## Steps

1. **Read first** — existing views/serializers/urls under `apps/<app>/{mobile,internal}/`, the
   service the view will call, and `.claude/concepts/clean-architecture.md` + `django-patterns.md` +
   `security.md`. Match patterns.
2. **Search** for an existing service/repository before writing a new one.
3. Build: DTO → repository (if new) → service → serializer (`to_dto()`) → thin view → register url.
4. Run `python manage.py test apps.<app>` and `ruff check . --fix && ruff format .`.

## DTO (`apps/<app>/dto/...`)

```python
from dataclasses import dataclass


@dataclass(frozen=True)
class HoldVerifyDTO:
    user: "User"
    otp: str
```

## Serializer (validate + build DTO)

```python
from rest_framework import serializers

from apps.transactions.dto.hold import HoldVerifyDTO


class HoldVerifySerializer(serializers.Serializer):
    otp = serializers.CharField()

    def to_dto(self, user) -> HoldVerifyDTO:
        return HoldVerifyDTO(user=user, **self.validated_data)
```

## View (thin)

```python
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.transactions.services.payment.hold import HoldVerifyService


class HoldVerifyView(APIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(request_body=HoldVerifySerializer, responses={200: CheckSerializer})
    def post(self, request, pk):
        serializer = HoldVerifySerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        dto = serializer.to_dto(user=request.user)
        check = HoldVerifyService(check=..., otp=dto.otp).execute()
        return Response(CheckSerializer(check).data, status=200)
```

## Rules

- No logic/ORM in views or serializers — push it to services + repositories.
- DTOs across every layer boundary. Inject deps (constructor, defaults).
- Soft deletes only; `@transaction.atomic` for multi-write; `.save(update_fields=[...])`.
- Enforce authz/ownership (IDOR), validate input, never leak PII/secrets in responses or logs.
- Full type hints, `logger` not `print`, enums not magic strings. Add tests (`new-test` pattern).
