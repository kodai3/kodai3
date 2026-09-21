---
name: setup-matt-pocock-skills
description: "このリポジトリをエンジニアリングスキル向けに設定する。issue tracker、triage ラベル語彙、ドメイン文書の配置。他のエンジニアリングスキルを使う前に 1 回走らせる。"
disable-model-invocation: true
---

# Setup Matt Pocock's Skills

エンジニアリングスキルが前提にする、リポジトリごとの設定を足場にする:

- **Issue tracker**: issue が住む場所（既定は GitHub。ローカル Markdown も標準で使える）
- **Triage labels**: 5 つの正規 triage ロールに使う文字列
- **Domain docs**: `CONTEXT.md` と ADR の場所、読むときのルール

これはプロンプト駆動のスキルであり、決定的なスクリプトではない。探索し、見つけたものを出し、ユーザーと確認してから書く。

## 手順

### 1. 探索する

今のリポジトリの出発点を理解する。あるものを読む。仮定しない:

- `git remote -v` と `.git/config`: GitHub リポジトリか。どれか
- ルートの `AGENTS.md` と `CLAUDE.md`: あるか。どちらかにすでに `## Agent skills` 節があるか
- ルートの `CONTEXT.md` と `CONTEXT-MAP.md`
- `docs/adr/` と `src/*/docs/adr/`
- `docs/agents/`: このスキルの以前の出力がすでにあるか
- `.scratch/`: ローカル Markdown の issue tracker 慣例がすでに使われている兆候
- `triage` スキルは入っているか（隣の `triage` フォルダ、または利用可能なスキルの `triage`）。Section B を走らせるかを決める
- モノレポの兆候: `pnpm-workspace.yaml`、`package.json` の `workspaces`、独自の `src/` を持つ `packages/*`。本当に大きなマルチパッケージリポジトリにだけある。なければ単一コンテキスト。ほぼすべてのリポジトリがこちら

### 2. 所見を出し、聞く

何があり、何が欠けているかを要約する。節は順に。1 節、1 答え、次へ。

各節は推奨答えを先に出し、ユーザーが一言で受け入れられるようにする。選択が本当に分岐するときだけ 1 行の説明を付ける。探索ですでに決まった節は飛ばす（`triage` が入っていなければ Section B、モノレポでなければ Section C）。

**Section A: Issue tracker.**

> 説明: "issue tracker" はこのリポジトリで issue が住む場所。`to-tickets`、`triage`、`to-spec` はそこから読み、そこに書く。`gh issue create` を呼ぶか、`.scratch/` に Markdown を書くか、他のワークフローに従うかを知る必要がある。このリポジトリで実際に作業を追跡する場所を選ぶ。

既定の姿勢: これらのスキルは GitHub 向けに設計されている。`git remote` が GitHub を指すならそれを提案する。GitLab（`gitlab.com` またはセルフホスト）なら GitLab を提案する。それ以外（またはユーザーが望むなら）次を出す:

- **GitHub**: issue はリポジトリの GitHub Issues（`gh` CLI）
- **GitLab**: issue はリポジトリの GitLab Issues（[`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **Local markdown**: issue はこのリポジトリの `.scratch/<feature>/` のファイル（ソロ、または remote がないリポジトリ向け）
- **Other**（Jira、Linear など）: ワークフローを 1 段落で書いてもらう。スキルは自由文として記録する

選択は `docs/agents/issue-tracker.md` に記録する。GitHub と GitLab のテンプレートは "PRs as a request surface" フラグを持ち、既定は **off**。off のままにし、話題にも上げない。外部 PR を triage キューに入れたいユーザーは、後からファイルでフラグをひっくり返せる。

**Section B: Triage ラベル語彙。** `triage` スキルが入っていなければこの節は丸ごと飛ばす（探索が教えてくれる）。入っていないスキルにラベルは不要。

入っていれば質問はちょうど 1 つ:

> 既定の triage ラベルを維持しますか？（推奨: **yes**）

既定は 5 つの正規ロールで、各ラベル文字列は名前と同じ: `needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。**yes** ならそのまま書く。ユーザーが no と言ったときだけ（たいていは tracker がすでに別名を使っている。例: `needs-triage` に対する `bug:triage`）、上書きを集め、`triage` が重複を作らず既存ラベルを付けるようにする。

**Section C: Domain docs.** 既定は **single-context**（ルートに `CONTEXT.md` 1 つ + `docs/adr/`）。ほぼすべてのリポジトリに合う。聞かずに書く。

**multi-context**（ルートの `CONTEXT-MAP.md` がコンテキストごとの `CONTEXT.md` を指す）を出すのは、探索がモノレポ兆候を見つけたときだけ。そのときどの配置にしたいか確認する。

### 3. 確認して編集する

ユーザーに草案を出す:

- 編集する `CLAUDE.md` / `AGENTS.md` に足す `## Agent skills` ブロック（選択ルールは手順 4）
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md`、`docs/agents/triage-labels.md` の内容（最後は `triage` が入っているときだけ）

書く前に編集させる。

### 4. 書く

**編集するファイルを選ぶ:**

- `CLAUDE.md` があればそれを編集する。
- なければ `AGENTS.md` があればそれを編集する。
- どちらもなければ、どちらを作るかユーザーに聞く。こちらで選ばない。

`CLAUDE.md` があるときに `AGENTS.md` を作らない（逆も同じ）。すでにある方を編集する。

選んだファイルにすでに `## Agent skills` ブロックがあれば、重複を足さず中身をその場で更新する。周囲の節へのユーザー編集は上書きしない。

ブロック:

```markdown
## Agent skills

### Issue tracker

[issue をどこで追跡するかの 1 行]。`docs/agents/issue-tracker.md` を見る。

### Triage labels

[ラベル語彙の 1 行]。`docs/agents/triage-labels.md` を見る。

### Domain docs

[配置の 1 行: "single-context" または "multi-context"]。`docs/agents/domain.md` を見る。
```

`### Triage labels` サブブロックと `docs/agents/triage-labels.md` は、`triage` が入っていて Section B が走ったときだけ。入っていなければ両方省略。

その後、このスキルフォルダのシードテンプレートを起点に docs ファイルを書く:

- [issue-tracker-github.md](./issue-tracker-github.md): GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md): GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md): ローカル Markdown issue tracker
- [triage-labels.md](./triage-labels.md): ラベル対応（`triage` が入っているときだけ）
- [domain.md](./domain.md): ドメイン文書の読み方 + 配置

"other" の issue tracker では、ユーザーの説明から `docs/agents/issue-tracker.md` をゼロから書く。

### 5. 完了

設定が終わったことと、これらのファイルをこれから読むエンジニアリングスキルを伝える。後から `docs/agents/*.md` を直接編集してよいこと、このスキルの再実行は tracker を切り替える、または最初からやり直すときだけ必要なことを伝える。
