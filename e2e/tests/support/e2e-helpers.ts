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

/**
 * PC/モバイル共通のサイドメニュー操作。
 * モバイル幅ではリンクが画面外にあるため、実ユーザーと同様にメニューボタンを開いてから操作する。
 */
export async function clickMenuLink(page: Page, name: string) {
  const link = page.getByRole('link', { name, exact: true }).first();

  if (!(await link.isVisible().catch(() => false))) {
    // モバイルでは sidebar 内の「サイドメニュー切替」もDOM上に存在するが、
    // 画面外に隠れている。実際に表示されている #mobile-menu-toggle を優先する。
    const mobileMenuButton = page.locator('#mobile-menu-toggle');
    if (await mobileMenuButton.isVisible().catch(() => false)) {
      await mobileMenuButton.click();
    } else {
      const menuButton = page.getByRole('button', { name: /メニューを開く|メニュー|menu/i }).filter({ visible: true }).first();
      if (await menuButton.count()) {
        await menuButton.click();
      } else {
        const fallback = page.locator('button.menu-toggle:visible, .mobile-menu-toggle:visible, .hamburger:visible, #menuToggle:visible, [aria-controls*="menu"]:visible').first();
        await expect(fallback, '表示中のモバイル用メニューボタンが見つかりません').toBeVisible();
        await fallback.click();
      }
    }
  }

  await expect(link, `メニュー「${name}」が表示されません`).toBeVisible();
  // WebKit/モバイルでは固定ヘッダー等がリンク上に重なり、通常 click が
  // viewport 判定で待ち続けることがある。表示確認後にDOM clickを使い、
  // 実際のリンク遷移そのものを検証する。
  if (page.viewportSize() && page.viewportSize()!.width <= 768) {
    await link.evaluate((el: HTMLElement) => el.click());
  } else {
    await link.click();
  }
}
