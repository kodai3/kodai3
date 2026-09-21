# CONTEXT.md の形式

## 構成

```md
# {コンテキスト名}

{このコンテキストが何で、なぜ存在するかを 1〜2 文で。}

## Language

**Order**:
{用語の説明を 1〜2 文}
_Avoid_: Purchase, transaction

**Invoice**:
納品後に顧客へ送る支払い請求。
_Avoid_: Bill, payment request

**Customer**:
注文する人または組織。
_Avoid_: Client, buyer, account
```

## ルール

- **意見を持つ。** 同じ概念に複数の語があるなら、最善の一つを選び、残りは `_Avoid_` に書く。
- **定義は短く。** 最大 1〜2 文。何をするかではなく、何であるかを定義する。
- **このプロジェクトのコンテキスト固有の用語だけ入れる。** timeout、エラー型、ユーティリティのような一般的なプログラミング概念は、いくら使っていても入れない。足す前に聞く: このコンテキスト固有の概念か、一般的なプログラミング概念か。前者だけが入る。
- **自然な塊があれば小見出しでグループ化する。** 全部が一つの領域ならフラットなリストでよい。

## 単一コンテキストと複数コンテキスト

**単一コンテキスト（ほとんどのリポジトリ）:** ルートに `CONTEXT.md` が 1 つ。

**複数コンテキスト:** ルートの `CONTEXT-MAP.md` がコンテキスト、場所、相互関係を列挙する:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md): 顧客の注文を受け、追跡する
- [Billing](./src/billing/CONTEXT.md): 請求書を作り、支払いを処理する
- [Fulfillment](./src/fulfillment/CONTEXT.md): 倉庫のピッキングと出荷を管理する

## Relationships

- **Ordering → Fulfillment**: Ordering が `OrderPlaced` を出し、Fulfillment が消費してピッキングを始める
- **Fulfillment → Billing**: Fulfillment が `ShipmentDispatched` を出し、Billing が消費して請求書を作る
- **Ordering ↔ Billing**: `CustomerId` と `Money` を共有する
```

どの構成かは次で判断する:

- `CONTEXT-MAP.md` があれば読んでコンテキストを探す
- ルートの `CONTEXT.md` だけなら単一コンテキスト
- どちらもなければ、最初の用語が固まったときにルートの `CONTEXT.md` を遅延作成する

複数コンテキストがあるときは、今の話題がどれに属するかを推論する。不明なら聞く。
