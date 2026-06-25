#!/usr/bin/env bash
# PreToolUse hook — blocks dangerous Bash before it runs.
# Wiring: settings.json → hooks.PreToolUse (matcher "Bash").
# Reads the tool call as JSON on stdin; exit 2 = block (stderr shown to Claude), exit 0 = allow.
# Requires: jq on PATH.
set -euo pipefail

input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
[ -z "$cmd" ] && exit 0

block() { echo "BLOCKED by guard.sh: $1" >&2; exit 2; }

# Destructive / irreversible
case "$cmd" in
  *"rm -rf /"*|*"rm -rf ~"*|*"rm -rf /*"*)        block "recursive root/home delete" ;;
  *":(){ :|:& };:"*)                                block "fork bomb" ;;
  *"mkfs."*|*" dd if="*of=/dev/*)                   block "disk overwrite" ;;
  *"chmod -R 777 "*)                                block "world-writable recursive chmod" ;;
esac

# Git history / remote hazards
case "$cmd" in
  *"git push --force "*|*"git push -f "*|*"git push --force-origin"*)
      block "force push — rewrites shared history; do it manually if intended" ;;
  *"git reset --hard"*origin/*)                     block "hard reset to remote — confirm manually" ;;
  *"git clean -fdx"*)                               block "git clean -fdx wipes untracked + ignored" ;;
esac

# Secret exfiltration smell: curl/wget piped to a shell
case "$cmd" in
  *curl*"| sh"*|*curl*"| bash"*|*wget*"| sh"*|*wget*"| bash"*)
      block "pipe-from-network-to-shell" ;;
esac

exit 0
