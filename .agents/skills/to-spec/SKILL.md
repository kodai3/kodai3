---
name: to-spec
description: "今の会話を spec にして issue tracker に公開する。インタビューはせず、すでに話したことの合成だけ。"
disable-model-invocation: true
---

このスキルは、今の会話とコードベース理解から spec を作る。ユーザーにインタビューしない。すでに知っていることを合成する。

issue tracker と triage ラベル語彙は渡されているはず。なければ `/setup-matt-pocock-skills` を案内する。

## 手順

1. まだ見ていなければリポジトリを探索し、現状を把握する。spec 全体でプロジェクトの用語集を使い、触る領域の ADR を尊重する。

2. この機能をテストする seam をスケッチする。既存の seam を新しい seam より優先する。可能な限り高い seam を使う。新しい seam が必要なら、置ける最も高い位置を提案する。コードベース全体の seam は少ないほどよい。理想は 1 つ。

   この seam がユーザーの想定と合うか確認する。

3. 下のテンプレートで spec を書き、プロジェクトの issue tracker に公開する。triage ラベル `ready-for-agent` を付ける。追加の triage は不要。

## Problem Statement

ユーザーから見た問題。

## Solution

ユーザーから見た解決。

## User Stories

長く、番号付きのユーザーストーリー。各ストーリーは次の形式:

1. As an, I want a, so that

例:

1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending

このリストは非常に広く、機能のあらゆる面をカバーする。

## Implementation Decisions

すでに決まった実装判断。含めてよいもの:

- 作る / 変えるモジュール
- 変えるモジュールのインターフェース
- 開発者からの技術的な確認
- アーキテクチャ判断
- スキーマ変更
- API 契約
- 具体的な相互作用

具体的なファイルパスやコード断片は入れない。すぐ古くなる。

例外: プロトタイプが、散文より正確に判断を符号化した断片（state machine、reducer、スキーマ、型の形）を出したなら、該当する判断の中にインラインし、プロトタイプ由来だと短く書く。動くデモではなく、判断が濃い部分だけ残す。

## Testing Decisions

決まったテスト判断。含めるもの:

- 良いテストの説明（外部の振る舞いだけを試し、実装詳細は試さない）
- テストするモジュール
- テストの先行事例（コードベース内の似た種類のテスト）

## Out of Scope

この spec の対象外。

## Further Notes

機能についての追加メモ。
