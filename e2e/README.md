# E2E / 手動テスト手順

このディレクトリは麻雀成績管理アプリのテスト用です。**E2Eは mahjong_test 以外では実行しないでください。**
自動テスト自身も `/db/info` を確認し、DB名が `mahjong_test`、接続ユーザーが `mahjong_test_user` でない場合は停止します。

## 1. 初回セットアップ（cloneした人）

前提: Java 21、Node.js/npm、Git。Windows PowerShellでリポジトリ直下から実行します。

### アプリ起動

このアプリは Spring Boot で起動します。E2E実行時は、必ずテストDB `mahjong_test` を指定してください。

#### 1. テストDB接続情報を設定

```powershell
$env:DB_URL="jdbc:mysql://<TEST_DB_HOST>:3306/mahjong_test?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=utf8&serverTimezone=Asia/Tokyo"
$env:DB_USERNAME="mahjong_test_user"
$env:DB_PASSWORD="<TEST_DB_PASSWORD>"
```

DBパスワードはGitにコミットしません。共有されたテストDB用の値を設定し、本番DBの値は使用しないでください。

#### 2. アプリを起動

リポジトリ直下から次を実行します。

```powershell
cd backend
mvn spring-boot:run
```

Maven Wrapperを利用する環境では、次でも構いません。

```powershell
cd backend
.\mvnw.cmd spring-boot:run
```

#### 3. 起動確認

ブラウザで次を開き、ログイン画面が表示されることを確認します。

`http://localhost:8080/mahjong-deploy/main/login-in`

アプリを起動したPowerShellはそのままにし、Playwrightは別のPowerShellから実行します。

### Playwright初回準備
別のPowerShellを開きます。

```powershell
cd e2e
npm ci
npx playwright install
$env:E2E_LOGIN_NAME="<利用者ログイン名>"
$env:E2E_LOGIN_PASSWORD="<利用者パスワード>"
$env:E2E_ADMIN_LOGIN_NAME="<管理者ログイン名>"
$env:E2E_ADMIN_LOGIN_PASSWORD="<管理者パスワード>"
```

## 2. 自動テスト

普段の確認はChromiumだけで十分です。

```powershell
npx playwright test --project=chromium
npx playwright show-report
```

全ブラウザ/スマホ相当まで確認する場合:

```powershell
npx playwright test
npx playwright show-report
```

画面を見ながら実行:

```powershell
npx playwright test --project=chromium --headed
```

Playwright UI:

```powershell
npx playwright test --ui
```

HTMLレポートでは各テストを開き、Screenshots/Attachmentsから全画面、削除前、確認/エラーポップアップ等を確認します。

## 3. 手動で画面操作して確認する方法

Playwrightを使わず、人がブラウザを操作する場合も**アプリは必ず mahjong_test で起動**してください。

### 利用者
1. ログイン画面: 未入力ログイン、誤ったID/パスワード、正常ログイン。
2. 利用者ホーム: サマリー表示、メニュー、ログアウト。
3. 新規対局: 日付、対局者検索、全選択/解除、4人未満エラー、4人選択、作成。
4. 対局編集: 日付検索、古い順/新しい順、編集詳細、点棒/順位/点数タブ、行追加。
5. 計算: 未入力/合計100,000点以外のエラー、100,000点の正常計算、順位・点数への反映、計算完了ポップアップ。
6. 削除: **削除前画面を確認** → 削除ボタン → 確認ポップアップ → キャンセル。実削除確認時はテストデータだけを削除。
7. 総合成績、総合成績グラフ、対人別成績: 表示崩れ、値、グラフを確認。
8. 対局カウンター: 登録、局数を超える和了/副露/立直/放銃の各エラー、編集、削除。各ポップアップも確認。
9. ログアウト後に `/user/home` を直接開き、ログイン画面へ戻されることを確認。

### 管理者
1. 管理者ログイン、管理者ホーム。
2. アカウント登録: 必須、名前10文字超過、パスワード確認不一致などの入力エラー。
3. グループ編集: 必須、10文字超過、正常な編集。
4. 利用者画面への遷移と表示。
5. ログアウト。

### PC/スマホ表示
PCは通常幅で全画面を確認します。スマホはEdge/Chrome DevToolsのデバイスツールバーでスマホ幅に切り替え、各主要画面、横スクロール、入力欄、モーダルを確認します。実機確認では数値キーボード表示時も操作し、ボタンが一時的に隠れる現仕様は許容します。

## 4. テストデータの扱い

テストDBのデータは変更・追加・削除して構いません。ただし繰り返し実行でデータを増やし続けない方針です。更新系テストは可能な限り既存テストデータを利用し、作成したデータは同一テスト内で削除します。失敗時に残ったE2Eデータは次回実行前に確認・整理してください。

## 5. 失敗した場合

HTMLレポートで失敗ケースを開き、Error、Test Steps、Screenshots、必要に応じてtrace/videoを確認します。画面仕様変更後にlocatorが合わなくなった場合は、アプリ不具合と決めつけず、まず対象画面のDOMとテストのlocatorを照合します。
