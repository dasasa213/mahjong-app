import { test, expect } from '@playwright/test';
import { assertTestDb, login, shot, closeAppModal, userName, userPassword } from '../support/e2e-helpers';

test.beforeEach(async({page})=>{await assertTestDb(page);await login(page,userName,userPassword,/\/user\/home$/);});

test('新規対局の検索・選択数・4人未満エラーを確認',async({page})=>{
  await page.goto('user/newgame/date'); await page.getByRole('button',{name:'対局者選択へ進む'}).click();
  const checks=page.locator('input.ck[name="userNames"]'); expect(await checks.count(),'同一グループに利用者が必要です').toBeGreaterThan(0);
  await page.locator('input[name="q"]').fill((await checks.first().getAttribute('value'))||''); await page.getByRole('button',{name:'検索'}).click(); await shot(page,'新規対局-ユーザー検索');
  await page.goto('user/newgame/players'); await page.locator('#checkAll').check(); await expect(page.locator('#count')).toHaveText(String(await page.locator('input.ck').count()));
  await page.locator('#checkAll').uncheck(); await page.getByRole('button',{name:'保存して作成'}).click(); await shot(page,'ポップアップ-新規対局-4人未満'); await closeAppModal(page);
});