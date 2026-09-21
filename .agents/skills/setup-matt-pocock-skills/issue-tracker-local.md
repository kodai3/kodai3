# Issue tracker: Local Markdown

このリポジトリの issue と spec は `.scratch/` の Markdown ファイル。

## 慣例

- 機能ごとに 1 ディレクトリ: `.scratch/<feature>/`
- spec は `.scratch/<feature>/spec.md`
- 実装 issue は `.scratch/<feature>/issues/<nn>-<slug>.md` に 1 ticket 1 ファイル。`01` から番号。1 つの結合ファイルにはしない
- triage 状態は各 issue ファイル先頭付近の `Status:` 行（ロール文字列は `triage-labels.md`）
- コメントと会話履歴はファイル末尾の `## Comments` 見出しの下に追記する

## スキルが "publish to the issue tracker" と言ったら

`.scratch/<feature>/` の下に新しいファイルを作る（ディレクトリがなければ作る）。

## スキルが "fetch the relevant ticket" と言ったら

参照されたパスのファイルを読む。ユーザーは普通、パスまたは issue 番号を直接渡す。

## Wayfinding operations

`/wayfinder` が使う。**地図** は 1 ファイル。ticket は子ファイル 1 つずつ。

- **地図**: `.scratch/<feature>/map.md`（Notes / Decisions-so-far / Fog の本文）。
- **子 ticket**: `.scratch/<feature>/issues/NN-<slug>.md`。`01` から番号。本文に質問。`Type:` 行が ticket 型（`research` / `prototype` / `grilling` / `task`）。`Status:` 行が `claimed` / `resolved`。
- **Blocking**: 先頭付近の `Blocked by: NN, NN` 行。列挙したファイルがすべて `resolved` なら unblocked。
- **Frontier**: `.scratch/<feature>/issues/` を走査し、開いていて、unblocked で、未 claim のファイル。番号順で最初が勝つ。
- **Claim**: 作業の前に `Status: claimed` にして保存する。
- **Resolve**: `## Answer` 見出しの下に答えを追記し、`Status: resolved` にし、`map.md` の Decisions-so-far に context pointer（要旨 + リンク）を追記する。
