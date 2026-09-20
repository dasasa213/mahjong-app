import { test, expect } from '@playwright/test';
import { assertTestDb, login, shot, userName, userPassword } from '../support/e2e-helpers';

test.beforeEach(async ({ page }) => { await assertTestDb(page); await login(page,userName,userPassword,/\/user\/home$/); });

test('利用者でログインして主要メニュー全画面を取得できる', async ({ page }) => {
  await shot(page, '主要画面-利用者ホーム');
  const destinations = [['新規対局',/\/user\/newgame\/date$/],['対局編集',/\/user\/matches\/edit/],['総合成績',/\/user\/overall$/],['総合成績（グラフ）',/\/user\/overall\/chart$/],['対人別成績',/\/user\/pairwise-rank$/],['対局カウンター',/\/user\/counter$/]] as const;
  for (const [name,url] of destinations) {
    await page.getByRole('link',{name,exact:true}).click(); await expect(page).toHaveURL(url);
    await expect(page.locator('body')).not.toContainText('Internal Server Error'); await shot(page,'主要画面-'+name);
  }
});

test('利用者の全メニュー・遷移画面・カウンターポップアップ', async ({ page }) => {
  const pages=[['利用者ホーム','user/home'],['新規対局-日付','user/newgame/date'],['対局編集一覧','user/matches/edit'],['総合成績','user/overall'],['総合成績グラフ','user/overall/chart'],['対人別成績','user/pairwise-rank'],['対局カウンター','user/counter']] as const;
  for(const [name,url] of pages){ await page.goto(url); await expect(page.locator('body')).not.toContainText('Internal Server Error'); await shot(page,'全画面-'+name); }
  await page.goto('user/newgame/date'); await page.getByRole('button',{name:'対局者選択へ進む'}).click(); await expect(page).toHaveURL(/\/user\/newgame\/players$/); await shot(page,'全画面-新規対局-対局者選択');
  await page.goto('user/matches/edit'); const edit=page.getByRole('link',{name:'編集'}).first(); if(await edit.count()){await edit.click(); await shot(page,'全画面-対局編集詳細');}
  await page.goto('user/counter'); for(const [id,v] of [['handCount','1'],['winCount','2']] as const) await page.locator('#'+id).evaluate((e:HTMLInputElement,x)=>e.value=x,v);
  await page.getByRole('button',{name:'登録',exact:true}).click(); await expect(page.locator('#messageModal')).toBeVisible(); await shot(page,'ポップアップ-カウンター入力エラー');
  await page.locator('#messageModal').getByRole('button',{name:'OK'}).click();
  const editCounter=page.getByRole('link',{name:'編集'}).first(); if(await editCounter.count()){await editCounter.click(); await shot(page,'全画面-カウンター編集');}
});
