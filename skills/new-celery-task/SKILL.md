---
name: new-celery-task
description: Scaffold a Celery background task in a Road24 service (FastAPI services or road24-backend Django) — task module, queue/routing, retry/idempotency, and how it's enqueued. Use for "add a background job for X", "move Y off the request path".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[repo] [task-name] [what it does]"
---

# Create a Celery Task

Add a background task for: $ARGUMENTS

Celery is used in `road24-backend` (Django) and the FastAPI services (`insurance`, `bff`, …).
`road24-insurance` also uses **RabbitMQ consumers/publisher** for event-driven flows — if this is an
event reaction rather than a fire-and-forget job, see that repo's `consumers/`+`publisher/` instead.

## Steps

1. **Read first** — the repo's existing tasks (`src/tasks/` or `apps/<app>/tasks.py`), the Celery app
   config, and queue/routing setup. Match registration and naming.
2. Put the **logic in a service**; the task is a thin wrapper that calls it (so it stays testable and
   reusable from the request path too).
3. Choose the queue/priority (backend has default/low/high workers + beat). Add routing if needed.
4. Make it **idempotent** and safe to retry; set sensible `max_retries`/backoff; never swallow errors silently.
5. Wire how it's enqueued (`.delay()`/`.apply_async()`), and schedule via beat if periodic.
6. Test the underlying service directly; test the task with the broker eager/mocked.

## FastAPI service pattern

```python
from core.celery_app import celery_app  # match the repo's actual import

@celery_app.task(name="insurance.sync_policy", bind=True, max_retries=3, default_retry_delay=10)
def sync_policy_task(self, policy_id: int) -> None:
    try:
        SyncPolicyService(policy_id=policy_id).execute()
    except TransientError as exc:
        raise self.retry(exc=exc)
```

## Django (road24-backend) pattern

```python
from celery import shared_task

@shared_task(bind=True, max_retries=3, default_retry_delay=10, queue="low_priority")
def recalc_fines_task(self, car_id: int) -> None:
    try:
        RecalcFinesService(car_id=car_id).execute()
    except TransientError as exc:
        raise self.retry(exc=exc)
```

## Rules

- Logic in a service, not in the task body. Tasks take **serializable** args only (ids, not ORM objects).
- Idempotent + retry-safe; guard against double-processing (dedupe key / status check).
- Pick the right queue/priority; long jobs off the high-priority queue.
- Log via the project logger (+ `road24-sdk` context); never leak secrets/PII.
- Run: backend `make worker|beat|flower`; FastAPI services per their Makefile/compose.
