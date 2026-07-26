---
name: conserving-tokens
description: Use when about to run grep/find/Read two or more times or read across multiple files, considering whether to delegate investigation to a subagent, or about to dump a large file/log directly into the main conversation.
---

# Conserving Tokens

## Overview

トークン浪費の主因は「長い会話contextの毎ターン再送」「grep/Read結果の生載せ」の2つ。判断のたびにこれらを避けられないか検討する。

## クイックリファレンス

| 状況 | 対応 |
|---|---|
| 現状把握、2ファイル以上の横断読み、grep/findを2回以上打ちそうな調査、PR/Issue/設計ドキュメント読解からの計画立案 | 打つ前にSubagentへの委譲を検討する。生の検索結果はcontextに残ると毎ターン再送されコストが累積するが、Subagentは要約のみ返す |
| 大きいファイル・長大ログの確認 | `Read`の`offset`/`limit`で必要箇所のみ読む。`cat`/`head`で長大出力をメインに流さない |
| 「ultracode」「workflowで」「並列で」等の明示的指示がない単発タスク | 大量Agent fan-out・Workflowは起動しない。便利そうでも単発タスクには使わない |

## 判定の例外

- ユーザーが「全部読んで」等を明示 → その指示を優先する
- 対象ファイルが1つに確定していてRead/Editが1〜2回で完結する場合 → Subagentに投げず直接実行してよい
