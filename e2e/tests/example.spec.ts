import { test, expect } from '@playwright/test';

const loginName = process.env.E2E_LOGIN_NAME;
const loginPassword = process.env.E2E_LOGIN_PASSWORD;

test.beforeAll(async ({ request }) => {
  const response = await request.get('db/info');
  expect(response.ok(), 'DB情報を取得できません').toBeTruthy();

  const info = await response.json();
  expect(info.database, 'E2Eはmahjong_test以外では実行禁止です').toBe('mahjong_test');
  expect(info.user, 'E2EはテストDB専用ユーザー以外では実行禁止です')
    .toContain('mahjong_test_user');
});

test('ログイン画面を表示できる', async ({ page }) => {
  await page.goto('main/login-in');
  await expect(page).toHaveTitle('ログイン');
  await expect(page.getByRole('button', { name: 'ログイン' })).toBeVisible();
});

test('利用者でログインして主要画面を巡回できる', async ({ page }) => {
  test.skip(!loginName || !loginPassword,
    'E2E_LOGIN_NAME / E2E_LOGIN_PASSWORD を設定するとログイン後テストを実行します');

  await page.goto('main/login-in');
  await page.getByRole('textbox', { name: 'ユーザ' }).fill(loginName!);
  await page.getByLabel('パスワード').fill(loginPassword!);
  await page.getByRole('button', { name: 'ログイン' }).click();

  await expect(page).toHaveURL(/\/user\/home$/);
  await expect(page.getByText('利用者ホーム', { exact: true }).first()).toBeVisible();

  const destinations = [
    ['総合成績', /\/user\/overall$/],
    ['総合成績（グラフ）', /\/user\/overall\/chart$/],
    ['対人別成績', /\/user\/pairwise-rank$/],
    ['対局カウンター', /\/user\/counter$/],
  ] as const;

  for (const [name, url] of destinations) {
    await page.getByRole('link', { name, exact: true }).click();
    await expect(page).toHaveURL(url);
    await expect(page.locator('body')).not.toContainText('Internal Server Error');
  }
});
