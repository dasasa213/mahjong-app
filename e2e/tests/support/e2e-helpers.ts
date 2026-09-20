import { expect, Page, test } from '@playwright/test';

export const userName = process.env.E2E_LOGIN_NAME;
export const userPassword = process.env.E2E_LOGIN_PASSWORD;
export const adminName = process.env.E2E_ADMIN_LOGIN_NAME;
export const adminPassword = process.env.E2E_ADMIN_LOGIN_PASSWORD;

export async function assertTestDb(page: Page) {
  const r = await page.request.get('db/info');
  expect(r.ok(), 'DB情報を取得できません').toBeTruthy();
  const info = await r.json();
  expect(info.database, 'mahjong_test以外ではE2E実行禁止').toBe('mahjong_test');
  expect(info.user, 'テストDB専用ユーザー以外ではE2E実行禁止').toContain('mahjong_test_user');
}

export async function login(page: Page, name?: string, password?: string, expected=/\/(user|admin)\/home$/) {
  test.skip(!name || !password, '対象ロールのE2Eログイン情報が必要です');
  await page.goto('main/login-in');
  await page.locator('input[name="loginName"]').fill(name!);
  await page.locator('input[name="password"]').fill(password!);
  await page.getByRole('button', { name: 'ログイン' }).click();
  await expect(page).toHaveURL(expected);
}

export async function shot(page: Page, name: string) {
  await test.info().attach(name + '.png', {
    body: await page.screenshot({ fullPage: true }),
    contentType: 'image/png',
  });
}

export async function closeAppModal(page: Page) {
  const modal = page.locator('.custom-modal:visible, #appModal:visible, [role="dialog"]:visible').first();
  if (await modal.count()) {
    const ok = modal.getByRole('button', { name: /OK|閉じる|キャンセル/ }).first();
    if (await ok.count()) await ok.click();
  }
}
