#!/usr/bin/env bash
# PostToolUse hook — formats the file Claude just edited, by extension.
# Wiring: settings.json → hooks.PostToolUse (matcher "Edit|Write|MultiEdit").
# Reads the tool call as JSON on stdin. Best-effort: never fail the turn (exit 0 always).
# Requires: jq. Formatters are optional — skipped if not installed.
set -uo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty')"
[ -z "$file" ] || [ ! -f "$file" ] && exit 0

have() { command -v "$1" >/dev/null 2>&1; }

case "$file" in
  *.py)
      have ruff && { ruff format "$file" >/dev/null 2>&1 || true; ruff check --fix "$file" >/dev/null 2>&1 || true; } ;;
  *.ts|*.tsx|*.js|*.jsx|*.vue|*.svelte|*.json|*.css|*.md)
      if have prettier; then prettier --write "$file" >/dev/null 2>&1 || true
      elif have npx; then npx --no-install prettier --write "$file" >/dev/null 2>&1 || true; fi ;;
  *.dart)
      have dart && { dart format "$file" >/dev/null 2>&1 || true; } ;;
  *.go)
      have gofmt && { gofmt -w "$file" >/dev/null 2>&1 || true; } ;;
  *.tf)
      have terraform && { terraform fmt "$file" >/dev/null 2>&1 || true; } ;;
esac

exit 0
