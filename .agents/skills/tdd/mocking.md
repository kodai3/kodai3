# いつモックするか

モックするのは **システム境界** だけ:

- 外部 API（決済、メールなど）
- データベース（場合による。テスト DB を優先）
- 時間 / 乱数
- ファイルシステム（場合による）

モックしない:

- 自分のクラス / モジュール
- 内部の協力者
- 自分で制御できるもの

## モックしやすい設計

システム境界では、モックしやすいインターフェースを設計する。

**1. 依存性注入を使う**

外部依存は中で作らず、渡す:

```typescript
// モックしやすい
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// モックしにくい
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. 汎用 fetcher より SDK 風のインターフェース**

条件分岐のある汎用関数 1 つではなく、外部操作ごとに専用関数を作る:

```typescript
// GOOD: 各関数を独立にモックできる
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch("/orders", { method: "POST", body: data }),
};

// BAD: モック側に条件分岐が必要
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

SDK 方式だと:

- 各モックは 1 つの形だけ返す
- テスト準備に条件分岐がない
- テストが触る endpoint が見やすい
- endpoint ごとに型が付く
