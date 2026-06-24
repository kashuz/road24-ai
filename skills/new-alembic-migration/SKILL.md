---
name: new-alembic-migration
description: Create and verify an Alembic migration for a Road24 FastAPI service (insurance, localization, gateway/bff where applicable) — autogenerate, review the SQL, handle data backfills, and plan a safe/zero-downtime rollout. Use for "add a column/table", "change the schema for X", "migrate Y".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[repo] [change description]"
---

# Create an Alembic Migration

Migration for: $ARGUMENTS

For the FastAPI services using SQLAlchemy + Alembic (`road24-insurance`, `road24-localization`, …).
(road24-backend uses Django migrations instead — use `makemigrations` there.)

## Steps

1. **Read first** — the model change you're migrating, `alembic.ini`, `alembic/env.py`, and the latest
   revision in `alembic/versions/` to see head + conventions.
2. **Update the SQLAlchemy model** first, then autogenerate:
   ```bash
   # inside the app container (per the repo, e.g. road24-insurance):
   docker exec -it road24-insurance-app alembic revision --autogenerate -m "add hold status"
   # or locally if configured:
   alembic revision --autogenerate -m "add hold status"
   ```
3. **Review the generated script** — autogenerate misses enum changes, server defaults, index renames,
   and data moves. Edit `upgrade()`/`downgrade()` until they're correct and reversible.
4. **Backfill data** in the migration (or a follow-up task) when adding non-null columns.
5. **Apply + verify:** `make migrate` (or `alembic upgrade head`); confirm `alembic downgrade -1`
   works on a scratch DB.

## Zero-downtime rules (expand → migrate → contract)

- Adding a NOT NULL column: add nullable + default → backfill → set NOT NULL in a later migration.
- Renames: add new → dual-write/backfill → switch reads → drop old. Don't rename-in-place on a live table.
- Create indexes `CONCURRENTLY` on large tables (outside a transaction — set the migration appropriately).
- Keep each migration small and reversible; never edit an already-applied/shipped revision — add a new one.

## Rules

- One logical change per migration; descriptive message. Down-migration must actually revert.
- Don't autogenerate-and-commit blindly — read the SQL. Watch enums, defaults, FKs, and data loss.
- Coordinate schema changes that affect a contract with `cross-service-contract` + the clients.
- Test data-affecting migrations against a copy, not prod.
