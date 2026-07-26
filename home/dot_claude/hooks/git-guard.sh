#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

[ -z "$cmd" ] && exit 0

is_destructive=false
is_broad_add=false

if printf '%s' "$cmd" | grep -qE '(^|[;&|]) *git +(reset +--hard|checkout +-- *\.?( |$)|checkout +\.( |$)|clean +-[a-zA-Z]*f|restore +(--staged +)?\.( |$))'; then
  is_destructive=true
fi

if printf '%s' "$cmd" | grep -qE '(^|[;&|]) *git +add +(-A|--all|\.)( |$)'; then
  is_broad_add=true
fi

$is_destructive || $is_broad_add || exit 0

repo_root=$(git rev-parse --show-toplevel 2> /dev/null || pwd)

if $is_destructive; then
  status=$(cd "$repo_root" && git status 2>&1 || true)
  jq -n --arg cmd "$cmd" --arg status "$status" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse", additionalContext: ("⚠️ 破壊的なgit操作を検知: `" + $cmd + "`\n実行前の git status:\n" + $status)}}'
  exit 0
fi

if $is_broad_add; then
  status=$(cd "$repo_root" && git status --short 2>&1 || true)
  jq -n --arg cmd "$cmd" --arg status "$status" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse", additionalContext: ("📋 広範な git add を検知: `" + $cmd + "`\nステージ対象:\n" + $status)}}'
  exit 0
fi
