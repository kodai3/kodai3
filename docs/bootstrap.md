# このリポジトリを clone して `setup.sh` を回す

新しい Mac では、このリポジトリを clone してから `./scripts/setup.sh` を実行する。公開 CLI（`npx kodai3 whoami`）とは別の、マシンセットアップ用の入口。

初回は上の手順まで読めば足りる。スクリプトの中身と、git に載せないものの一覧は下を必要なときに引く。

```bash
git clone https://github.com/kodai3/kodai3.git
cd kodai3
./scripts/setup.sh
```

既にあるファイルは上書きしない。置き換えるときは `--force` を付ける。

```bash
./scripts/setup.sh --force
```

## Homebrew・zsh・gh までがスクリプトの範囲

- `scripts/install-apps.sh` — Homebrew がなければ入れ、`Brewfile` の formulae と casks を入れる（`gh`、`direnv`、`fnm`、`peco`、GUI アプリ）
- `scripts/setup-zsh.sh` — Oh My Zsh とカスタムプラグイン（`zsh-syntax-highlighting`、`zsh-autosuggestions`、`zsh-completions`、`zsh-history-substring-search`）を入れ、`dotfiles/zsh/.zshrc` と `dotfiles/zsh/custom/kodai.zsh` を symlink する。`.zshrc` では組み込みプラグインの `git`、`fnm`、`direnv` を有効にする。履歴検索は peco を Ctrl-R に割り当てる。そのマシンだけの設定は `~/.zshrc.local`
- `scripts/setup-gh.sh` — 標準入力が TTY なら `gh auth login` を走らせ、続けて `gh auth setup-git`。トークンは git に載せない

## PC をまたぐ skill と、新しいリポジトリへ持っていく skill をここに置く

持ち歩きたい skill の本体は `.agents/skills`。別の Mac ではこのリポジトリを clone すれば入る。新しいリポジトリに入れるときも、ここから持っていく。

`.claude/skills` と `.cursor/skills` はそこへの git symlink。このリポジトリを開いていれば Claude Code、Cursor、Codex から見える。`$HOME` にはコピーしない。

本文は日本語。元は [mattpocock/skills](https://github.com/mattpocock/skills)。新しいリポジトリでは先に `/setup-matt-pocock-skills` を 1 回走らせ、issue tracker とラベルを記録する。

開発はこれらの skill で進める。次はすべて人間が打つ（AI 側からは起動しない）。

- **霧が濃い / 1 セッションに収まらない**: `/wayfinder` で decision ticket の地図を作り、1 枚ずつ解いて道を出す
- **設計を詰める**: `/grill-with-docs`（ADR と用語を書きながら詰める）→ `/to-spec` → `/to-tickets`
- **実装**: `/implement`（`/tdd` を挟み、`/code-review` で締める）
- **Issue の整理**: `/triage`

## 秘密情報は git に載せない

SSH キー、`.npmrc`、MCP の OAuth、プラグインのキャッシュは git に置かない。手作業の残りは [CHECKLIST.md](../CHECKLIST.md)。
