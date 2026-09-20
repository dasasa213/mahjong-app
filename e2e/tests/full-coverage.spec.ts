import { test, expect, Page } from '@playwright/test';

const userName = process.env.E2E_LOGIN_NAME;
const userPassword = process.env.E2E_LOGIN_PASSWORD;
const adminName = process.env.E2E_ADMIN_LOGIN_NAME;
const adminPassword = process.env.E2E_ADMIN_LOGIN_PASSWORD;

async function shot(page: Page, name: string) {
  await test.info().attach(name + '.png', { body: await page.screenshot({ fullPage: true }), contentType: 'image/png' });
}
async function login(page: Page, name?: string, password?: string) {
  test.skip(!name || !password, '対象ロールのE2Eログイン情報が必要です');
  await page.goto('main/login-in');
  await page.locator('input[name="loginName"]').fill(name!);
  await page.locator('input[name="password"]').fill(password!);
  await page.getByRole('button', { name: 'ログイン' }).click();
}
async function assertTestDb(page: Page) {
  const r = await page.request.get('db/info');
  expect(r.ok()).toBeTruthy();
  const info = await r.json();
  expect(info.database, 'mahjong_test以外ではE2E実行禁止').toBe('mahjong_test');
  expect(info.user, 'テストDB専用ユーザー以外ではE2E実行禁止').toContain('mahjong_test_user');
}
test.beforeEach(async ({ page }) => { await assertTestDb(page); });

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

test('利用者の全メニュー・遷移画面・カウンターポップアップ', async ({ page }) => {
  await login(page, userName, userPassword);
  await expect(page).toHaveURL(/\/user\/home$/);
  const pages = [
    ['利用者ホーム','user/home'], ['新規対局-日付','user/newgame/date'], ['対局編集一覧','user/matches/edit'],
    ['総合成績','user/overall'], ['総合成績グラフ','user/overall/chart'], ['対人別成績','user/pairwise-rank'], ['対局カウンター','user/counter']
  ] as const;
  for (const [name,url] of pages) {
    await page.goto(url); await expect(page.locator('body')).not.toContainText('Internal Server Error'); await shot(page, '全画面-'+name);
  }
  await page.goto('user/newgame/date');
  await page.getByRole('button', { name: '対局者選択へ進む' }).click();
  await expect(page).toHaveURL(/\/user\/newgame\/players$/); await shot(page, '全画面-新規対局-対局者選択');

  await page.goto('user/matches/edit');
  const edit = page.getByRole('link', { name: '編集' }).first();
  if (await edit.count()) { await edit.click(); await shot(page, '全画面-対局編集詳細'); }

  await page.goto('user/counter');
  for (const [id,v] of [['handCount','1'],['winCount','2']] as const)
    await page.locator('#'+id).evaluate((el: HTMLInputElement,x)=>el.value=x,v);
  await page.getByRole('button',{name:'登録',exact:true}).click();
  await expect(page.locator('#messageModal')).toBeVisible(); await shot(page,'ポップアップ-カウンター入力エラー');

  const editCounter = page.getByRole('link',{name:'編集'}).first();
  if (await editCounter.count()) { await editCounter.click(); await shot(page,'全画面-カウンター編集'); }
});

test('利用者の削除確認ポップアップ', async ({ page }) => {
  await login(page,userName,userPassword); await page.goto('user/matches/edit');
  const del=page.getByRole('button',{name:'削除'}).first();
  test.skip(await del.count()===0,'削除確認用データなし');
  await shot(page,'削除前-対局'); await del.click(); await expect(page.locator('#delModal')).toBeVisible(); await shot(page,'ポップアップ-対局削除確認');
  await page.getByRole('button',{name:'キャンセル'}).click();
});

test('管理者の全画面', async ({ page }) => {
  await login(page,adminName,adminPassword);
  await expect(page).toHaveURL(/\/admin\/home$/);
  const pages=[['管理者ホーム','admin/home'],['アカウント登録','admin/accounts'],['グループ編集','admin/group/edit']] as const;
  for(const [name,url] of pages){ await page.goto(url); await expect(page.locator('body')).not.toContainText('Internal Server Error'); await shot(page,'全画面-'+name); }
});

test('管理者の入力エラー表示を網羅', async ({ page }) => {
  await login(page,adminName,adminPassword);
  await page.goto('account/register');
  await page.locator('input[name="name"]').fill('E2EUSER');
  await page.locator('input[name="password"]').fill('abc');
  await page.locator('input[name="passwordConfirm"]').fill('xyz');
  await page.locator('form').getByRole('button').last().click();
  await expect(page.locator('body')).toContainText('パスワードと確認用が一致しません'); await shot(page,'エラー-管理者-アカウント登録');

  await page.goto('admin/group/edit');
  await page.locator('input[name="newName"]').fill('12345678901');
  await page.locator('form').getByRole('button').last().click();
  await expect(page.locator('body')).toContainText('グループ名は10文字以内'); await shot(page,'エラー-管理者-グループ編集');
});
