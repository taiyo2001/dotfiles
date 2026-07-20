#!/bin/bash
set -e

# Docker / CI 環境ではスキップ
if [[ -f /.dockerenv ]] || [[ "${CI:-}" == "true" ]]; then
  echo "Docker/CI 環境のため Claude Code MCP サーバー設定をスキップします。"
  exit 0
fi

if ! command -v claude &> /dev/null; then
  echo "claude コマンドが見つからないため MCP サーバー設定をスキップします。"
  exit 0
fi

if claude mcp get context7 &> /dev/null; then
  echo "context7 MCP サーバーは設定済みです。"
else
  echo "context7 MCP サーバー (upstash/context7-mcp) をユーザースコープで登録します。"
  claude mcp add context7 -s user -- npx -y @upstash/context7-mcp
fi
