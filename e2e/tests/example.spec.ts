import { test, expect, Page } from '@playwright/test';

const loginName = process.env.E2E_LOGIN_NAME;
const loginPassword = process.env.E2E_LOGIN_PASSWORD;

async function attach(page: Page, name: string) {
  await test.info().attach(name + '.png', {
    body: await page.screenshot({ fullPage: true }),
    contentType: 'image/png',
  });
}

test.beforeAll(async ({ request }) => {
  const response = await request.get('db/info');
  expect(response.ok(), 'DB情報を取得できません').toBeTruthy();
  const info = await response.json();
  expect(info.database, 'E2Eはmahjong_test以外では実行禁止です').toBe('mahjong_test');
  expect(info.user, 'E2EはテストDB専用ユーザー以外では実行禁止です').toContain('mahjong_test_user');
});

async function login(page: Page) {
  test.skip(!loginName || !loginPassword, 'E2E_LOGIN_NAME / E2E_LOGIN_PASSWORD が必要です');
  await page.goto('main/login-in');
  await page.locator('input[name="loginName"]').fill(loginName!);
  await page.locator('input[name="password"]').fill(loginPassword!);
  await page.getByRole('button', { name: 'ログイン' }).click();
  await expect(page).toHaveURL(/\/user\/home$/);
}

test('ログイン画面を表示できる', async ({ page }) => {
  await page.goto('main/login-in');
  await expect(page).toHaveTitle('ログイン');
  await expect(page.getByRole('button', { name: 'ログイン' })).toBeVisible();
  await attach(page, '主要画面-ログイン');
});

test('利用者でログインして主要メニュー全画面を取得できる', async ({ page }) => {
  await login(page);
  await attach(page, '主要画面-利用者ホーム');

  const destinations = [
    ['新規対局', /\/user\/matches\/new$/],
    ['対局編集', /\/user\/matches\/edit/],
    ['総合成績', /\/user\/overall$/],
    ['総合成績（グラフ）', /\/user\/overall\/chart$/],
    ['対人別成績', /\/user\/pairwise-rank$/],
    ['対局カウンター', /\/user\/counter$/],
  ] as const;

  for (const [name, url] of destinations) {
    await page.getByRole('link', { name, exact: true }).click();
    await expect(page).toHaveURL(url);
    await expect(page.locator('body')).not.toContainText('Internal Server Error');
    await attach(page, '主要画面-' + name);
  }
});

test('対局カウンターの入力検証ポップアップを取得できる', async ({ page }) => {
  await login(page);
  await page.goto('user/counter');
  await page.locator('#handCount').evaluate((el: HTMLInputElement) => el.value = '1');
  await page.locator('#winCount').evaluate((el: HTMLInputElement) => el.value = '2');
  await page.getByRole('button', { name: '登録', exact: true }).click();
  await expect(page.locator('#messageModal')).toBeVisible();
  await expect(page.locator('#messageModalText')).toHaveText('和了数は局数以下にしてください。');
  await attach(page, 'ポップアップ-カウンター入力エラー');
});

test('対局編集の削除確認ポップアップを取得できる', async ({ page }) => {
  await login(page);
  await page.goto('user/matches/edit');
  const deleteButton = page.getByRole('button', { name: '削除' }).first();
  test.skip(await deleteButton.count() === 0, '削除確認用の対局データがありません');
  await attach(page, '削除前-対局編集');
  await deleteButton.click();
  await expect(page.locator('#delModal')).toBeVisible();
  await attach(page, 'ポップアップ-対局削除確認');
  await page.getByRole('button', { name: 'キャンセル' }).click();
});
