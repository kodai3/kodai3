# Issue tracker: GitLab

このリポジトリの issue と spec は GitLab issue。操作はすべて [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## 慣例

- **issue を作る**: `glab issue create --title "..." --description "..."`。複数行の description は heredoc。`--description -` でエディタを開く。
- **issue を読む**: `glab issue view <n> --comments`。機械可読なら `-F json`。
- **issue を列挙する**: `glab issue list -F json`。適切な `--label` フィルタを付ける。
- **コメントする**: `glab issue note <n> --message "..."`。GitLab はコメントを "notes" と呼ぶ。
- **ラベルの付与 / 削除**: `glab issue update <n> --label "..."` / `--unlabel "..."`。複数ラベルはカンマ区切り、またはフラグの繰り返し。
- **閉じる**: `glab issue close <n>`。`glab issue close` は閉じコメントを受けないので、先に `glab issue note --message "..."` で説明を投稿してから閉じる。
- **Merge request**: GitLab は PR を "merge request" と呼ぶ。`glab mr create`、`glab mr view`、`glab mr note` など。`gh pr ...` と同じ形で、`pr` の代わりに `mr`、`comment` / `--body` の代わりに `note` / `--message`。

リポジトリは `git remote -v` から推論する。clone 内で走らせれば `glab` が自動でやる。

## Merge request を triage 面にするか

**MRs as a request surface: no.** _（このリポジトリが外部 merge request を機能要求として扱うなら `yes` にする。`/triage` がこのフラグを読む。）_

`yes` のとき、MR は issue と同じラベルと状態を通り、`glab mr` 相当を使う:

- **MR を読む**: `glab mr view <n> --comments` と、diff は `glab mr diff <n>`。
- **triage する外部 MR を列挙する**: `glab mr list -F json`。残すのは著者がプロジェクトの member / owner ではない MR（コントリビュータの MR。メンテナの進行中作業ではない）。
- **コメント / ラベル / 閉じる**: `glab mr note`、`glab mr update --label` / `--unlabel`、`glab mr close`。

GitHub と違い、GitLab は issue と MR の番号が別なので、メンテナがどの面を指しているかが分かれば `#42` は曖昧ではない。

## スキルが "publish to the issue tracker" と言ったら

GitLab issue を作る。

## スキルが "fetch the relevant ticket" と言ったら

`glab issue view <n> --comments` を走らせる。

## Wayfinding operations

`/wayfinder` が使う。**地図** は 1 issue。ticket はその **子** issue。

- **地図**: ラベル `wayfinder:map` の 1 issue。Notes / Decisions-so-far / Fog の本文を持つ。`glab issue create --label wayfinder:map`。（native epic がある GitLab ティアでは epic が地図を持ってもよい。ラベル付き issue はどこでも動く。）
- **子 ticket**: description 先頭に `Part of #<map>` を持ち、ラベル `wayfinder:<type>`（`research` / `prototype` / `grilling` / `task`）を付ける issue。claim したら、運転している開発者へ assign する。
- **Blocking**: GitLab の **native blocking link**。正本で、UI に見える表現。`/blocked_by #<n>` quick action を note として投稿する（`glab issue note --message "/blocked_by #<n>"`）。native blocking link は Premium / Ultimate。無料ティア（または使えないところ）では description 先頭の `Blocked by: #<n>, #<n>` 行に落とす。blocker がすべて閉じたら ticket は unblocked。
- **Frontier クエリ**: 地図の子にスコープした `glab issue list -F json`。開いている blocker があるものを落とす。開いている issue への native `blocked_by` リンク（`glab api projects/:id/issues/:iid/links`）、または `Blocked by` 行の開いている issue、または assignee。地図の順で最初が勝つ。
- **Claim**: `glab issue update <n> --assignee @me`。セッションの最初の書き込み。
- **Resolve**: `glab issue note <n> --message "<answer>"`、次に `glab issue close <n>`、次に地図の Decisions-so-far に context pointer（要旨 + リンク）を追記する。
