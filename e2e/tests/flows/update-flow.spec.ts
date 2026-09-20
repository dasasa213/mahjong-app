import { test, expect } from '@playwright/test';
import { assertTestDb, login, shot, userName, userPassword } from '../support/e2e-helpers';

test.beforeEach(async ({ page }) => { await assertTestDb(page); await login(page, userName, userPassword, /\\/user\\/home$/); });

test('新規対局を作成し、確認後に削除できる', async ({ page }) => {
  let gameId: string | undefined;

  try {
    await page.goto('user/newgame/date');
    await page.getByRole('button', { name: '対局者選択へ進む' }).click();
    await expect(page).toHaveURL(/\/user\/newgame\/players$/);

    const players = page.locator('input.ck[name="userNames"]');
    expect(await players.count(), '同一グループに利用者が4人以上必要です').toBeGreaterThanOrEqual(4);
    for (let i = 0; i < 4; i++) await players.nth(i).check();

    await page.getByRole('button', { name: '保存して作成' }).click();
    await expect(page.getByRole('heading', { name: '対局を作成しました' })).toBeVisible();

    const body = await page.locator('body').innerText();
    const match = body.match(/game_id：\s*(\d{5})/);
    expect(match, '作成したgame_idを取得できません').not.toBeNull();
    gameId = match![1];

    await shot(page, '更新系-新規対局作成');

    await page.goto('user/matches/edit');
    const row = page.locator('table.list tbody tr').filter({ hasText: gameId });
    await expect(row).toHaveCount(1);
    await shot(page, '削除前-作成した対局');
    await row.getByRole('button', { name: '削除' }).click();
    await expect(page.locator('#delModal')).toBeVisible();
    await shot(page, 'ポップアップ-作成した対局の削除確認');
    await page.locator('#agreeChk').check();
    await page.getByRole('button', { name: 'OK（削除）' }).click();
    await expect(page.getByText(`ID ${gameId} を削除しました。`)).toBeVisible();
    gameId = undefined;
    await shot(page, '更新系-新規対局削除後');
  } finally {
    // 途中失敗時も、作成済みIDが分かっていればUI経由で残骸を削除する。
    if (gameId) {
      await page.goto('user/matches/edit');
      const row = page.locator('table.list tbody tr').filter({ hasText: gameId });
      if (await row.count()) {
        await row.getByRole('button', { name: '削除' }).click();
        await page.locator('#agreeChk').check();
        await page.getByRole('button', { name: 'OK（削除）' }).click();
      }
    }
  }
});

test('対局カウンターを登録・編集・削除できる', async ({ page }) => {
  let cleanupNeeded = false;

  try {
    await page.goto('user/counter');

    const values: Record<string, number> = {
      handCount: 8, winCount: 2, callCount: 3, riichiCount: 4, dealInCount: 1,
    };
    for (const [id, value] of Object.entries(values)) {
      await page.locator('#' + id).evaluate((el: HTMLInputElement, v) => el.value = String(v), value);
    }
    await page.getByRole('button', { name: '登録', exact: true }).click();
    await expect(page.getByText('登録しました。')).toBeVisible();
    cleanupNeeded = true;

    let row = page.locator('.history-table tbody tr').filter({ hasText: '8' }).filter({ hasText: '4' });
    await expect(row.first()).toBeVisible();
    await shot(page, '更新系-カウンター登録');

    await row.first().getByRole('link', { name: '編集' }).click();
    await page.locator('#handCount').evaluate((el: HTMLInputElement) => el.value = '9');
    await page.locator('#winCount').evaluate((el: HTMLInputElement) => el.value = '3');
    await page.getByRole('button', { name: '更新' }).click();
    await expect(page.getByText('更新しました。')).toBeVisible();
    await shot(page, '更新系-カウンター編集');

    row = page.locator('.history-table tbody tr').filter({ hasText: '9' }).filter({ hasText: '3' });
    await shot(page, '削除前-カウンター履歴');
    await row.first().getByRole('button', { name: '削除' }).click();
    await expect(page.locator('#deleteConfirmModal')).toBeVisible();
    await shot(page, 'ポップアップ-カウンター削除確認');
    await page.locator('#deleteConfirmModal').getByRole('button', { name: 'OK' }).click();
    await expect(page.getByText('削除しました。')).toBeVisible();
    cleanupNeeded = false;
    await shot(page, '更新系-カウンター削除後');
  } finally {
    if (cleanupNeeded) {
      await page.goto('user/counter');
      const row = page.locator('.history-table tbody tr').filter({ hasText: /8|9/ });
      if (await row.count()) {
        await row.first().getByRole('button', { name: '削除' }).click();
        await page.locator('#deleteConfirmModal').getByRole('button', { name: 'OK' }).click();
      }
    }
  }
});
