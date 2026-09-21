---
name: implement
description: spec または ticket 一式に書かれた作業を実装する。
disable-model-invocation: true
---

ユーザーが spec または ticket で示した作業を実装する。

事前に合意した seam では、可能な限り `/tdd` を使う。

型チェックはこまめに回す。個別のテストファイルもこまめに回す。フルのテストスイートは最後に一度だけ。

終わったら `/code-review` でレビューする。

作業は現在のブランチに commit する。
