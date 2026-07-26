# コミット前チェックリスト

プッシュ前に実施するタスク一覧。CIはこれに加えて Secret Scanning と zsh 起動ベンチマーク（main ブランチのみ）も実行する。

## 一括実行

`make ci/local`（`lefthook run pre-push` のエイリアス）で以下を全てまとめて実行できる。CIの `push_ci.yml` とほぼ同一の内容。

- フォーマット: `shfmt -i 2 -ci -sr -d .`
- Lint: `find . -name '*.sh' -not -path './.git/*' -not -path './home/dot_zsh/*' | xargs shellcheck --severity=warning`（`home/dot_zsh/` は対象外）
- テスト: `bats tests/`
- Terraform: `terraform -chdir=terraform fmt -recursive` / `terraform -chdir=terraform validate`（`terraform/*.tf` に変更がある場合のみ）

## Terraformの差分確認

Terraformを変更した場合は `make tf/plan` で意図した差分のみになっているか確認する。
