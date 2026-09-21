---
name: to-tickets
description: 計画・spec・今の会話を tracer-bullet の ticket 一式に分解する。各 ticket は blocking の辺を宣言し、設定済み tracker に公開する（ローカルなら ticket ごとにテキスト、本物の tracker なら native の blocking リンク）。
disable-model-invocation: true
---

# To Tickets

計画、spec、会話を **ticket** 一式に分解する。各 ticket は tracer-bullet の垂直スライスであり、自分を **block** する ticket を宣言する。

issue tracker と triage ラベル語彙は渡されているはず。なければ `/setup-matt-pocock-skills` を案内する。

## 手順

### 1. 文脈を集める

会話にすでに入っているものから進める。ユーザーが引数として参照（spec のパス、issue 番号、URL）を渡したら、取得して本文とコメントを全部読む。

### 2. コードベースを探索する（任意）

まだ探索していなければ、コードの現状を把握する。ticket のタイトルと本文はプロジェクトの用語集を使い、触る領域の ADR を尊重する。

実装を楽にする prefactor の機会を探す。「変更を簡単にしてから、簡単な変更をする。」

### 3. 垂直スライスを草案する

作業を **tracer bullet** の ticket に分解する。

- 各スライスは、すべての層（スキーマ、API、UI、テスト）を狭くても **完走** する。1 層だけの水平スライスではない
- 完了したスライスは、単体でデモできる、または検証できる
- 各スライスは、新しいコンテキストウィンドウ 1 つに収まる大きさ
- prefactor があるなら先にやる

各 ticket に **blocking の辺** を付ける。開始前に完了していなければならない他の ticket。blocker がない ticket はすぐ始められる。

**広いリファクタは垂直スライスの例外。** **広いリファクタ** は、1 つの機械的変更（カラムのリネーム、共有シンボルの型変更）の **blast radius** がコードベース全体に広がり、1 回の編集で何千もの呼び出しが壊れ、どの垂直スライスも green で着地できないもの。tracer bullet に押し込まない。**expand–contract** で並べる。まず expand: 旧形の横に新形を足し、何も壊さない。次に呼び出し側を blast radius 単位（パッケージ、ディレクトリ）のバッチで移す。各バッチは expand に block された独自の ticket。旧形が残るのでバッチごとに CI は green。最後に contract: 呼び出しがゼロになったら旧形を消す。すべての migrate バッチに block された ticket。バッチ単体でも green を保てないなら、順序は同じまま統合ブランチを共有し、最終の integrate-and-verify ticket をみんなで block する。green が約束されるのはそこだけ。

### 4. ユーザーに確認する

提案する分解を番号付きリストで出す。各 ticket について:

- **Title**: 短い説明名
- **Blocked by**: 先に完了すべき他の ticket（あれば）
- **What it delivers**: この ticket が動かす end-to-end の振る舞い

聞くこと:

- 粒度は妥当か（粗すぎ / 細かすぎ）
- blocking の辺は正しいか。本当にゲートになる ticket だけに依存しているか
- マージやさらなる分割が必要か

ユーザーが分解を承認するまで繰り返す。

### 5. 設定済み tracker に公開する

承認した ticket を公開する。**やり方** は `/setup-matt-pocock-skills` が設定した tracker に依存する。ticket 自体は同じで、blocking の辺の形だけが変わる。

- **ローカルファイル** → `.scratch/<feature>/issues/<nn>-<slug>.md` に 1 ticket 1 ファイル。依存順に `01` から番号（blocker が先）。各ファイルの "Blocked by" は依存する番号/タイトル。下の per-ticket テンプレートを使う。1 ファイルにまとめない。
- **本物の issue tracker（GitHub、Linear など）** → 依存順（blocker が先）に 1 ticket 1 issue。blocking の辺が本物の ID を参照できるようにする。プラットフォームに native の blocking / sub-issue 関係があればそれを使う。なければ各 ticket の "Blocked by" に blocking issue を書く。指示がなければ triage ラベル `ready-for-agent` を付ける。ticket は作った時点でエージェントが掴める。

**frontier** を進める。blocker がすべて終わった ticket。純粋な線形チェーンなら上から下。

親 issue は閉じない、変更しない。

## 確認用の草案（公開前）

```markdown
<n>: <title>

**What to build:** この ticket が動かす end-to-end の振る舞い。ユーザー視点。層ごとの実装リストではない。

**Blocked by:** ゲートになる ticket の番号/タイトル。または "None (can start immediately)"。

**Status:** ready-for-agent

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2
```

## 公開する ticket の本文

```markdown
## Parent

tracker 上の親 issue への参照（元が既存 issue なら。そうでなければこの節は省略）。

## What to build

この ticket が動かす end-to-end の振る舞い。ユーザー視点。層ごとの実装ではない。

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

- 各 blocking ticket への参照。または "None (can start immediately)"。
```

どちらの形でも、具体的なファイルパスやコード断片は避ける。すぐ古くなる。例外: プロトタイプが散文より正確に判断を符号化した断片（state machine、reducer、スキーマ、型の形）を出したならインラインし、プロトタイプ由来だと短く書く。動くデモではなく、判断が濃い部分だけ。
