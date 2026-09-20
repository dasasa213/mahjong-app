import { test, expect } from '@playwright/test';
import { assertTestDb, login, shot, closeAppModal, userName, userPassword } from '../support/e2e-helpers';
test.beforeEach(async({page})=>{await assertTestDb(page);await login(page,userName,userPassword,/\/user\/home$/);});
async function detailPage(page:any){await page.goto('user/matches/edit');const links=page.getByRole('link',{name:'編集'});const n=await links.count();test.skip(n===0,'編集対象データがありません');const hrefs=[];for(let i=0;i<n;i++){const h=await links.nth(i).getAttribute('href');if(h)hrefs.push(h);}for(const h of hrefs){await page.goto(h);if(await page.locator('.mt-module').count())return true;}return false;}
test('対局編集の検索・並び順・詳細タブ・行追加を確認',async({page})=>{
 await page.goto('user/matches/edit');const f=page.locator('#searchForm'),from=f.locator('input[name="from"]'),to=f.locator('input[name="to"]');if(await from.count()){await from.fill('2020-01-01');await to.fill('2099-12-31');await f.getByRole('button',{name:'検索'}).click();}
 const order=f.locator('#orderInput');
 // 現在の並び順と逆の値にして、検索後にその値が維持されることを確認する。
 // 固定で asc を期待すると、サーバ側が現在値 desc を返すケースで誤検知になる。
 const currentOrder=(await order.inputValue()) || 'desc';
 const nextOrder=currentOrder==='asc' ? 'desc' : 'asc';
 await order.evaluate((e:HTMLInputElement,value)=>e.value=value,nextOrder);
 await f.getByRole('button',{name:'検索'}).click();
 await expect(f.locator('#orderInput')).toHaveValue(nextOrder);
 await shot(page,'対局編集-検索結果');
 test.skip(!(await detailPage(page)),'詳細表示できる対局データがありません');await shot(page,'対局編集-詳細-点棒');
 for(const [k,l] of [['rank','順位'],['points','点数']] as const){const tab=page.locator(`.mt-module .tab[data-tab="${k}"]`);await expect(tab).toBeVisible();await tab.click();await expect(page.locator(`#mt-pane-${k}`)).toHaveClass(/active/);await shot(page,'対局編集-詳細-'+l);}
 const before=await page.locator('#mt-pane-score tbody tr').count();await page.getByRole('button',{name:'＋ 行を追加'}).click();await expect(page.locator('#mt-pane-score tbody tr')).toHaveCount(before+1);await shot(page,'対局編集-行追加後');
});
test('対局編集の計算エラーと正常計算ポップアップを確認',async({page})=>{
 test.skip(!(await detailPage(page)),'詳細表示できる対局データがありません');let inputs=page.locator('#mt-pane-score table.mt-score tbody tr').first().locator('td input');test.skip(await inputs.count()!==4,'4人の対局編集データがありません');
 for(let i=0;i<4;i++)await inputs.nth(i).fill('');await inputs.nth(0).fill('1000');await page.getByRole('button',{name:'計算',exact:true}).click();await shot(page,'ポップアップ-対局編集-計算エラー');await closeAppModal(page);
 for(const [i,v] of ['40000','30000','20000','10000'].entries())await inputs.nth(i).fill(v);await page.getByRole('button',{name:'計算',exact:true}).click();await shot(page,'ポップアップ-対局編集-計算完了');await closeAppModal(page);
 const tab=page.locator('.mt-module .tab[data-tab="rank"]');await tab.click();await expect(page.locator('#mt-pane-rank tbody tr').first().locator('input').nth(0)).toHaveValue('1');await shot(page,'対局編集-正常計算結果');
});
test('対局編集の削除確認ポップアップ',async({page})=>{await page.goto('user/matches/edit');const del=page.getByRole('button',{name:'削除'}).first();test.skip(await del.count()===0,'削除確認用データなし');await shot(page,'削除前-対局');await del.click();await expect(page.locator('#delModal')).toBeVisible();await shot(page,'ポップアップ-対局削除確認');await page.getByRole('button',{name:'キャンセル'}).click();});