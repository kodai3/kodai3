# Domain Docs

エンジニアリングスキルがコードベースを探索するとき、このリポジトリのドメイン文書をどう消費するか。

## 探索の前に読むもの

- ルートの **`CONTEXT.md`**、または
- ルートに **`CONTEXT-MAP.md`** があればそれ: コンテキストごとに 1 つの `CONTEXT.md` を指す。話題に関係するものを読む。
- **`docs/adr/`**: これから触る領域に関わる ADR を読む。複数コンテキストのリポジトリでは `src/<context>/docs/adr/` も、コンテキスト固有の判断を見る。

これらのファイルがなければ **黙って進む**。無いことを指摘しない。先に作ることも提案しない。`/domain-modeling` スキル（`/grill-with-docs` から到達する）が、用語や判断が実際に固まったときに遅延作成する。

## ファイル構成

単一コンテキスト（ほとんどのリポジトリ）:

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

複数コンテキスト（ルートに `CONTEXT-MAP.md` がある）:

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← システム全体の判断
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← コンテキスト固有の判断
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## 用語集の語彙を使う

出力がドメイン概念を名指しするとき（issue タイトル、リファクタ提案、仮説、テスト名）、`CONTEXT.md` が定義した語を使う。用語集が明示的に避ける同義語へ漂わない。

必要な概念がまだ用語集になければ、それは信号。プロジェクトが使わない言語を発明している（考え直す）か、本物の隙間がある（`/domain-modeling` 向けにメモする）。

## ADR の衝突を出す

出力が既存 ADR と矛盾するなら、黙って上書きせず明示する:

> _ADR-0007（event-sourced orders）と矛盾するが、再開する価値がある。なぜなら…_
