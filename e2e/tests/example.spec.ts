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
  await page.locator('input[name="loginName"]').fill(loginName!);
  await page.locator('input[name="password"]').fill(loginPassword!);
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
    await test.info().attach(`${name}.png`, {
      body: await page.screenshot({ fullPage: true }),
      contentType: 'image/png',
    });
  }
});

test('対局カウンターの入力検証が動作する', async ({ page }) => {
  test.skip(!loginName || !loginPassword,
    'E2E_LOGIN_NAME / E2E_LOGIN_PASSWORD を設定すると更新系テストを実行します');

  await page.goto('main/login-in');
  await page.locator('input[name="loginName"]').fill(loginName!);
  await page.locator('input[name="password"]').fill(loginPassword!);
  await page.getByRole('button', { name: 'ログイン' }).click();
  await expect(page).toHaveURL(/\/user\/home$/);

  await page.goto('user/counter');

  // DBを書き換えずに、画面側の入力検証を確認する。
  await page.locator('#handCount').evaluate((el: HTMLInputElement) => el.value = '1');
  await page.locator('#winCount').evaluate((el: HTMLInputElement) => el.value = '2');
  await page.getByRole('button', { name: '登録', exact: true }).click();

  await expect(page.locator('#messageModal')).toBeVisible();
  await expect(page.locator('#messageModalText'))
    .toHaveText('和了数は局数以下にしてください。');
  await test.info().attach('対局カウンター-入力検証.png', {
    body: await page.screenshot({ fullPage: true }),
    contentType: 'image/png',
  });
});
