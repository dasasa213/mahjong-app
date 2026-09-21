import { test, expect } from '@playwright/test';
import { assertTestDb, login, shot, userName, userPassword } from '../support/e2e-helpers';

test.beforeEach(async ({ page }) => assertTestDb(page));

test('ログイン画面を表示できる', async ({ page }) => {
  await page.goto('main/login-in');
  await expect(page).toHaveTitle('ログイン');
  await expect(page.getByRole('button', { name: 'ログイン' })).toBeVisible();
  await shot(page, '主要画面-ログイン');
});

test('未ログイン・ログインエラー画面とポップアップ', async ({ page }) => {
  await page.goto('main/login-in');
  await shot(page, '全画面-ログイン');
  await page.getByRole('button', { name: 'ログイン' }).click();
  await shot(page, 'エラー-ログイン必須');
  await page.locator('input[name="loginName"]').fill('__invalid_e2e__');
  await page.locator('input[name="password"]').fill('__invalid__');
  await page.getByRole('button', { name: 'ログイン' }).click();
  await expect(page.locator('body')).toContainText('ユーザー名またはパスワードが違います');
  await shot(page, 'エラー-ログイン失敗');
});

test('ログアウトして未ログイン保護を確認', async ({ page }) => {
  await login(page, userName, userPassword, /\/user\/home$/);
  await page.getByRole('link', { name: 'ログアウト', exact: true }).click();
  await expect(page).toHaveURL(/\/main\/login/);
  await page.goto('user/home');
  await expect(page).toHaveURL(/\/main\/login/);
  await shot(page, '認証-ログアウト後アクセス');
});
