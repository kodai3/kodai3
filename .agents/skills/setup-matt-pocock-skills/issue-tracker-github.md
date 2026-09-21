# Issue tracker: GitHub

このリポジトリの issue と spec は GitHub issue。操作はすべて `gh` CLI。

## 慣例

- **issue を作る**: `gh issue create --title "..." --body "..."`。複数行の本文は heredoc。
- **issue を読む**: `gh issue view <n> --comments`。コメントは `jq` で絞り、ラベルも取る。
- **issue を列挙する**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`。適切な `--label` と `--state` フィルタを付ける。
- **コメントする**: `gh issue comment <n> --body "..."`
- **ラベルの付与 / 削除**: `gh issue edit <n> --add-label "..."` / `--remove-label "..."`
- **閉じる**: `gh issue close <n> --comment "..."`

リポジトリは `git remote -v` から推論する。clone 内で走らせれば `gh` が自動でやる。

## Pull request を triage 面にするか

**PRs as a request surface: no.** _（このリポジトリが外部 PR を機能要求として扱うなら `yes` にする。`/triage` がこのフラグを読む。）_

`yes` のとき、PR は issue と同じラベルと状態を通り、`gh pr` 相当を使う:

- **PR を読む**: `gh pr view <n> --comments` と、diff は `gh pr diff <n>`。
- **triage する外部 PR を列挙する**: `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`。残すのは `authorAssociation` が `CONTRIBUTOR`、`FIRST_TIME_CONTRIBUTOR`、`NONE` のもの（`OWNER` / `MEMBER` / `COLLABORATOR` は落とす）。
- **コメント / ラベル / 閉じる**: `gh pr comment`、`gh pr edit --add-label` / `--remove-label`、`gh pr close`。

GitHub は issue と PR で番号空間を共有するので、裸の `#42` はどちらでもありうる。`gh pr view 42` で解決し、だめなら `gh issue view 42` に落とす。

## スキルが "publish to the issue tracker" と言ったら

GitHub issue を作る。

## スキルが "fetch the relevant ticket" と言ったら

`gh issue view <n> --comments` を走らせる。

## Wayfinding operations

`/wayfinder` が使う。**地図** は 1 issue。ticket はその **子** issue。

- **地図**: ラベル `wayfinder:map` の 1 issue。Notes / Decisions-so-far / Fog の本文を持つ。`gh issue create --label wayfinder:map`。
- **子 ticket**: 地図に GitHub sub-issue としてリンクした issue（sub-issues endpoint への `gh api`）。sub-issue が使えなければ、地図本文のタスクリストに子を足し、子の本文先頭に `Part of #<map>` を置く。ラベル: `wayfinder:<type>`（`research` / `prototype` / `grilling` / `task`）。claim したら、運転している開発者へ assign する。
- **Blocking**: GitHub の **native issue dependencies**。正本で、UI に見える表現。辺を足す: `gh api --method POST repos/<owner>/<repo>/issues/<issue_number>/dependencies/blocked_by -F issue_id=<id>`。`<id>` は blocker の数値 **database id**（`gh api repos/<owner>/<repo>/issues/<number> --jq .id`。`#number` でも `node_id` でもない）。GitHub は `issue_dependencies_summary.blocked_by` を報告する（開いている blocker だけ。生きているゲート）。dependencies が使えなければ、子本文の先頭に `Blocked by: #<n>, #<n>` 行を置く。blocker がすべて閉じたら ticket は unblocked。
- **Frontier クエリ**: 地図の開いている子を列挙する（`gh issue list --state open`、地図の sub-issue / タスクリストにスコープ）。開いている blocker があるもの（`issue_dependencies_summary.blocked_by > 0`、または `Blocked by` 行の開いている issue）と assignee があるものを落とす。地図の順で最初が勝つ。
- **Claim**: `gh issue edit <n> --add-assignee @me`。セッションの最初の書き込み。
- **Resolve**: `gh issue comment <n> --body "<answer>"`、次に `gh issue close <n>`、次に地図の Decisions-so-far に context pointer（要旨 + リンク）を追記する。
