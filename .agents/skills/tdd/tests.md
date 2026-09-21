# 良いテストと悪いテスト

## 良いテスト

**統合寄りのスタイル**: 本物のインターフェース越しに試す。内部部品のモックではない。

```typescript
// GOOD: 観察できる振る舞いを試す
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

特徴:

- ユーザー / 呼び出し側が気にする振る舞いを試す
- 公開 API だけを使う
- 内部のリファクタに耐える
- HOW ではなく WHAT を書く
- テストあたり論理的なアサーションは 1 つ

## 悪いテスト

**実装詳細のテスト**: 内部構造に結合している。

```typescript
// BAD: 実装詳細を試す
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

危険信号:

- 内部の協力者をモックする
- private メソッドを試す
- 呼び出し回数 / 順序を断言する
- 振る舞いが変わっていないのにリファクタで壊れる
- テスト名が WHAT ではなく HOW を書く
- インターフェースではなく外部手段で検証する

```typescript
// BAD: 検証のためにインターフェースを迂回する
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: インターフェース越しに検証する
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**同語反復のテスト**: 期待値が実装の言い直しなので、構成上必ず通る。

```typescript
// BAD: 期待値をコードと同じ計算で再計算している
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// GOOD: 期待値は独立した既知のリテラル
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
