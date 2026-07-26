# CLAUDE.md

このリポジトリで作業する際のプロジェクト固有の方針。

## バージョンアップ方針

依存関係のバージョンアップは [Renovate Upgrade Best Practices](https://docs.renovatebot.com/upgrade-best-practices/#general-recommendations) の一般的な推奨事項に従う。

- `config:recommended` ではなく `config:best-practices` を使う
- 更新は頻繁に・小さい単位で行う（月次・週次等でまとめてバッチ更新する運用は避ける）
- Dependency Dashboard issue を活用する
- 更新時はchangelogを確認する
- メジャーバージョン更新にも適切に対応する
