# E2E テスト構成

Playwright テストは機能単位で配置します。

- `auth/` : ログイン、ログアウト、未ログイン保護
- `user/` : 利用者画面。画面遷移、新規対局、対局編集、カウンター
- `admin/` : 管理者画面、入力検証
- `flows/` : DBを更新する一連の業務フロー
- `support/` : ログイン、テストDB確認、スクリーンショット等の共通処理

## 実行
```powershell
cd e2e
npm ci
npx playwright install chromium
npx playwright test --project=chromium
npx playwright show-report
```

テストは `/db/info` を確認し、DB名が `mahjong_test`、DBユーザーが `mahjong_test_user` を含まない環境では失敗させます。

## 命名方針
`*.spec.ts` は画面・機能単位にします。「coverage」「example」のように内容が分からない名前へテストを追加しないでください。
共通処理は `support/e2e-helpers.ts` に置きます。

## 今後の追加
正常系、異常系、境界値を同じ機能のspecへまとめます。スクリーンショットは主要画面、操作前、ポップアップ表示中、操作後を必要に応じて添付します。
