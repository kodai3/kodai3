# エージェント brief の書き方

エージェント brief は、issue または PR が `ready-for-agent` になったときに投稿する構造化コメント。AFK エージェントが作業する正本の仕様。元の本文と議論は文脈。エージェント brief が契約。

brief は **エージェントが何をすべきか** を述べる。issue ならゼロから変更を作ること。PR なら *既存 diff に対して* 残っていること: 仕上げる、隙間を埋める、レビュー指摘に応える。原則は同じ。下の PR 例が差分を示す。

## 原則

### 精密さより耐久

issue は `ready-for-agent` に日や週とどまることがある。その間にコードベースは変わる。ファイルがリネーム、移動、リファクタされても使えるように書く。

- **する**: インターフェース、型、振る舞いの契約を書く
- **する**: エージェントが見つける、または変えるべき具体的な型、関数シグネチャ、設定の形を名指しする
- **しない**: ファイルパスを参照する。古くなる
- **しない**: 行番号を参照する
- **しない**: 今の実装構造がそのまま残ると仮定する

### 手続きではなく振る舞い

**何を** システムがすべきかを書く。**どう** 実装するかではない。エージェントはコードベースを新しく探索し、実装判断は自分でする。

- **良い:** "`SkillConfig` 型は optional の `schedule` フィールド（型 `CronExpression`）を受け付けるべき"
- **悪い:** "src/types/skill.ts を開き、42 行目に schedule フィールドを足す"
- **良い:** "ユーザーが引数なしで `/triage` を走らせたら、注意が要る issue の要約が見えるべき"
- **悪い:** "main handler 関数に switch を足す"

### 完結した受け入れ条件

エージェントは終わりを知る必要がある。すべてのエージェント brief に、具体的でテスト可能な受け入れ条件を付ける。各条件は独立に検証できる。

- **良い:** "`gh issue list --label needs-triage` が、初期分類を通った issue を返す"
- **悪い:** "Triage が正しく動くべき"

### 明示的なスコープ境界

対象外を書く。エージェントが金メッキしたり、隣接機能について仮定したりするのを防ぐ。

## テンプレート

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** 何が起きるべきかの 1 行

**Current behavior:**
今起きること。バグなら壊れている振る舞い。
enhancement なら、機能が乗る現状。

**Desired behavior:**
エージェントの作業後に起きるべきこと。
エッジケースとエラー条件を具体的に。

**Key interfaces:**
- `TypeName`: 何が変わり、なぜか
- `functionName()` の戻り型: 今返すものと返すべきもの
- Config の形: 必要な新しい設定

**Acceptance criteria:**
- [ ] 具体的でテスト可能な条件 1
- [ ] 具体的でテスト可能な条件 2
- [ ] 具体的でテスト可能な条件 3

**Out of scope:**
- この issue で変えてはいけない、扱ってはいけないもの
- 関連して見えるが別件の隣接機能
```

## 例

### 良いエージェント brief（bug）

```markdown
## Agent Brief

**Category:** bug
**Summary:** Skill description の切り詰めが単語の途中で切れ、壊れた出力になる

**Current behavior:**
skill description が 1024 文字を超えると、単語境界に関係なくちょうど
1024 文字で切られる。単語の途中で終わる description になる
（例: "Use when the user wants to confi"）。

**Desired behavior:**
切り詰めは 1024 文字より前の最後の単語境界で切れ、
切り詰めを示す "..." を付ける。

**Key interfaces:**
- `SkillMetadata` 型の `description` フィールド: 型変更は不要。
  ただしそれを埋める validation / processing が単語境界を尊重する必要がある
- SKILL.md の frontmatter を読み、description を取り出す関数

**Acceptance criteria:**
- [ ] 1024 文字未満の description は変わらない
- [ ] 1024 文字超の description は 1024 より前の最後の単語境界で切られる
- [ ] 切られた description は "..." で終わる
- [ ] "..." を含む総長は 1024 文字を超えない

**Out of scope:**
- 1024 文字制限そのものの変更
- 複数行 description のサポート
```

### 良いエージェント brief（enhancement）

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** 却下した機能要求を追跡する `.out-of-scope/` ディレクトリを足す

**Current behavior:**
機能要求が却下されると、issue は `wontfix` ラベルとコメントで閉じる。
判断や理由の永続記録はない。似た将来の要求では、メンテナが
以前の議論を思い出すか探す必要がある。

**Desired behavior:**
却下した機能要求は `.out-of-scope/<concept>.md` に記録する。
判断、理由、その機能を求めた全 issue へのリンクを残す。
新しい issue を triage するときは、これらのファイルを照合する。

**Key interfaces:**
- `.out-of-scope/` の Markdown 形式: 各ファイルは
  `# Concept Name` 見出し、`**Decision:**` 行、`**Reason:**` 行、
  issue リンク付きの `**Prior requests:**` リストを持つ
- triage ワークフローは早い段階で `.out-of-scope/*.md` を全部読み、
  入ってきた issue を概念の類似で照合する

**Acceptance criteria:**
- [ ] 機能を wontfix で閉じると `.out-of-scope/` にファイルを作る / 更新する
- [ ] ファイルは判断、理由、閉じた issue へのリンクを含む
- [ ] 一致する `.out-of-scope/` ファイルがすでにあれば、新しい issue は
      重複を作らず "Prior requests" に追記する
- [ ] triage 中、既存の `.out-of-scope/` を確認し、新しい issue が
      以前の却下に一致したら出す

**Out of scope:**
- 自動照合（人が一致を確認する）
- 以前却下した機能の再開
- バグレポート（`.out-of-scope/` に入るのは enhancement の却下だけ）
```

### 良いエージェント brief（PR）

PR では "Current behavior" は diff の状態を書き、brief はゼロから作るのではなく仕上げるか直すことを求める。

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** コントリビュータの `triage list` 向け `--json` 出力フラグを仕上げる

**Current behavior:**
PR は issue 一覧を JSON にする `--json` フラグを足す。ハッピーパスは動き、
diff はプロジェクトのコマンド構造に合う。隙間が 2 つ残る: エラーはまだ
人間向けテキスト（JSON ではない）で、新しいフラグにテストがない。

**Desired behavior:**
`--json` ではすべての出力（エラー含む）が stdout 上の正しい JSON で、
コマンドの終了コードは変わらない。フラグがなければ既存の人間向け出力は触らない。

**Key interfaces:**
- コマンドのエラー経路は `--json` のときプレーンテキストではなく
  `{ "error": string }` を出す
- PR がすでに足した serializer を再利用する。2 つ目を入れない

**Acceptance criteria:**
- [ ] `triage list --json` は成功とエラーの両方で妥当な JSON を出す
- [ ] 終了コードは非 JSON コマンドと一致する
- [ ] `--json` の成功出力とエラー 1 件をテストがカバーする
- [ ] 既定（非 JSON）出力はバイト単位で変わらない

**Out of scope:**
- 他コマンドへの `--json` 追加
- PR がすでに定義した成功ペイロードの JSON 形の変更
```

### 悪いエージェント brief

```markdown
## Agent Brief

**Summary:** triage のバグを直す

**What to do:**
triage のやつが壊れている。main ファイルを見て直す。
150 行付近の関数に問題がある。

**Files to change:**
- src/triage/handler.ts (line 150)
- src/types.ts (line 42)
```

悪い理由:

- カテゴリがない
- 曖昧な説明（"triage のやつが壊れている"）
- 古くなるファイルパスと行番号
- 受け入れ条件がない
- スコープ境界がない
- 現状と望ましい振る舞いの説明がない
