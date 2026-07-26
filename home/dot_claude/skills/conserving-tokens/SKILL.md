---
name: conserving-tokens
description: Use when starting a task on a costly model, about to run grep/find/Read two or more times or read across multiple files, considering whether to delegate investigation to a subagent, weighing whether to suggest /clear after a topic change or task completion, or about to dump a large file/log directly into the main conversation.
---

# Conserving Tokens

## Overview

トークン浪費の主因は「長い会話contextの毎ターン再送」「重い作業へのOpus常用」「grep/Read結果の生載せ」の3つ。判断のたびにこれらを避けられないか検討する。

## クイックリファレンス

| 状況 | 対応 |
|---|---|
| 話題転換・タスク完了の節目 | 応答末尾に一言 `/clear` を提案する。同一セッションで一度提案したら繰り返さない。要約コストが残り続ける `/compact` より `/clear` を優先 |
| Opusで単純作業(現状調査、typo修正や一行修正のような小修正、コミット、PR作成、ドキュメント更新)を開始した直後 | 最初の応答で一度だけ `/model` でのSonnet/Haiku切替を提案する。設計判断・複雑なデバッグ・大規模リファクタ・難しいレビューでは提案しない |
| 現状把握、2ファイル以上の横断読み、grep/findを2回以上打ちそうな調査、PR/Issue/設計ドキュメント読解からの計画立案 | 打つ前にSubagentへの委譲を検討する。生の検索結果はcontextに残ると毎ターン再送されコストが累積するが、Subagentは要約のみ返す |
| 大きいファイル・長大ログの確認 | `Read`の`offset`/`limit`で必要箇所のみ読む。`cat`/`head`で長大出力をメインに流さない |
| 「ultracode」「workflowで」「並列で」等の明示的指示がない単発タスク | 大量Agent fan-out・Workflowは起動しない。便利そうでも単発タスクには使わない |

## 判定の例外

- ユーザーが「節約モードで」等を明示 → より積極的に適用する(Subagent委譲を増やす、モデル提案を強める)
- ユーザーが「Opusのままで」「全部読んで」等を明示 → その指示を優先する
- 対象ファイルが1つに確定していてRead/Editが1〜2回で完結する場合 → Subagentに投げず直接実行してよい

## 例外の判定に迷う場合

上の表の項目に明確に当てはまる場合は必ず対応する(迷って見送らない)。表のどれにも明確に当てはまらない境界的なケースでのみ、モデル切替提案を見送ってよい。節約提案自体の分量は応答本体より長くしない。
