# Out-of-scope ナレッジベース

リポジトリの `.out-of-scope/` は、却下した機能要求の永続記録を置く。目的は 2 つ:

1. **組織の記憶**: 機能を却下した理由。issue を閉じても理由が消えない
2. **重複排除**: 以前の却下に一致する新しい issue が来たら、再議論せず以前の判断を出せる

## ディレクトリ構成

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

**概念** ごとに 1 ファイル。issue ごとではない。同じものを求める複数 issue は 1 ファイルにまとめる。

## ファイル形式

データベース項目より短い設計文書に近い、緩く読める文体で書く。段落、コード例、実例を使い、初めて読む人にも理由が分かるようにする。

```markdown
# Dark Mode

このプロジェクトは dark mode もユーザー向け theming もサポートしない。

## Why this is out of scope

描画パイプラインは `ThemeConfig` で定義した単一のカラーパレットを前提にする。
複数テーマを支えるには次が必要になる:

- コンポーネントツリー全体を包む theme context provider
- コンポーネントごとのテーマ対応スタイル解決
- ユーザーのテーマ設定を残す永続層

これは大きなアーキテクチャ変更で、コンテンツ制作に集中するこのプロジェクトの焦点と合わない。
theming は、出力を埋め込む、または再配布する下流の消費者の関心事。

```ts
// 今の ThemeConfig は実行時切り替え向けではない:
interface ThemeConfig {
  colors: ColorPalette; // 単一パレット、ビルド時に解決
  fonts: FontStack;
}
```

## Prior requests

- #42: "Add dark mode support"
- #87: "Night theme for accessibility"
- #134: "Dark theme option"
```

### ファイル名

概念の短い kebab-case: `dark-mode.md`、`plugin-system.md`、`graphql-api.md`。ディレクトリを眺めただけで、ファイルを開かずに何が却下されたか分かる名前。

### 理由の書き方

理由は中身があるものにする。「欲しくない」ではなくなぜか。良い理由が参照するもの:

- プロジェクトのスコープや哲学（「このプロジェクトは X に集中する。theming は下流の関心事」）
- 技術的制約（「これを支えるには Y が必要で、Z アーキテクチャと衝突する」）
- 戦略的判断（「B ではなく A を選んだ。なぜなら…」）

理由は耐久する。一時的な事情（「今は忙しい」）は参照しない。それは却下ではなく延期。

## いつ `.out-of-scope/` を見るか

triage 中（手順 1: 文脈を集める）に `.out-of-scope/` の全ファイルを読む。新しい issue を評価するとき:

- 要求が既存の out-of-scope 概念に一致するか確認する
- 照合はキーワードではなく概念の類似。「night theme」は `dark-mode.md` に一致する
- 一致があればメンテナに出す: 「これは `.out-of-scope/dark-mode.md` に似ています。以前は [理由] で却下しました。今も同じですか？」

メンテナは次ができる:

- **Confirm**: 新しい issue を既存ファイルの "Prior requests" に足し、閉じる
- **Reconsider**: out-of-scope ファイルを消すか更新し、issue は通常の triage に進む
- **Disagree**: 関連するが別件。通常の triage に進む

## いつ `.out-of-scope/` に書くか

**enhancement**（bug ではない）を `wontfix` として *却下* したときだけ。enhancement PR にも issue と同じく適用する。却下した PR をここに残し、同じ要求が新しいコードとして戻らないようにする。

**すでに実装されている** ために `wontfix` で閉じるときは **書かない**。作済みの機能であり、却下ではない。記録すると重複チェックが偽の却下で汚染される。代わりに、閉じるコメントが機能の場所を指す。

流れ:

1. メンテナが機能要求を対象外と決める
2. 一致する `.out-of-scope/` ファイルがすでにあるか確認する
3. あれば: 新しい issue を "Prior requests" に追記する
4. なければ: 概念名、判断、理由、最初の prior request で新しいファイルを作る
5. 判断を説明し `.out-of-scope/` ファイルに言及するコメントを issue に投稿する
6. `wontfix` ラベルで issue を閉じる

## out-of-scope ファイルの更新と削除

メンテナが以前却下した概念について考えを変えたら:

- `.out-of-scope/` ファイルを削除する
- スキルは古い issue を再開しない。それらは履歴
- 再考のきっかけになった新しい issue は通常の triage に進む
