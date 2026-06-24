# road24-tinting

**Tinting-permit service** — handles vehicle window-tinting permits for the Road24 platform.
Early-stage / smaller surface than the other services.

- **Repo:** kashuz/road24-tinting · **Stack:** Python 3.12, FastAPI, `uv`. Branch: `main`.
- **Has `.claude/`:** no (candidate for `bootstrap-claude-project`).

## Structure (`src/`)
`main.py` · `api/`. Infra in `core/`. `docker-compose.yaml`, `Dockerfile`, `Makefile` present.
As it grows, follow the standard FastAPI clean-3-layer (`Router → Service → Repository`) used by the
other services — see `platform-map.md` and `insurance.md`/`bff.md` as the reference shape.

## Commands
```bash
make up | down | logs | test     # confirm against the Makefile
pytest ; ruff check src/ ; ruff format src/ ; mypy src/
```

## Notes
- Verify the actual layout before assuming — it may not yet have services/repositories split out.
  When adding real logic, introduce the service/repository layers rather than putting it in `api/`.
- Good first candidate to onboard with `/bootstrap-claude-project` to get agents + a CLAUDE.md.
