import { test, expect, Page } from '@playwright/test';

const userName = process.env.E2E_LOGIN_NAME;
const userPassword = process.env.E2E_LOGIN_PASSWORD;
const adminName = process.env.E2E_ADMIN_LOGIN_NAME;
const adminPassword = process.env.E2E_ADMIN_LOGIN_PASSWORD;

async function assertTestDb(page: Page) {
  const r = await page.request.get('db/info');
  expect(r.ok(), 'DB情報を取得できません').toBeTruthy();
  const info = await r.json();
  expect(info.database, 'mahjong_test以外ではE2E実行禁止').toBe('mahjong_test');
  expect(info.user, 'テストDB専用ユーザー以外ではE2E実行禁止').toContain('mahjong_test_user');
}
async function login(page: Page, name?: string, password?: string, expected=/\/(user|admin)\/home$/) {
  test.skip(!name || !password, '対象ロールのE2Eログイン情報が必要です');
  await page.goto('main/login-in');
  await page.locator('input[name="loginName"]').fill(name!);
  await page.locator('input[name="password"]').fill(password!);
  await page.getByRole('button',{name:'ログイン'}).click();
  await expect(page).toHaveURL(expected);
}
async function shot(page: Page, name: string) {
  await test.info().attach(name+'.png',{body:await page.screenshot({fullPage:true}),contentType:'image/png'});
}
async function closeAppModal(page: Page) {
  const modal=page.locator('.custom-modal:visible, #appModal:visible, [role="dialog"]:visible').first();
  if(await modal.count()){
    const ok=modal.getByRole('button',{name:/OK|閉じる|キャンセル/}).first();
    if(await ok.count()) await ok.click();
  }
}

test.beforeEach(async({page})=>assertTestDb(page));

test.describe('利用者・詳細機能',()=>{
  test.beforeEach(async({page})=>login(page,userName,userPassword,/\/user\/home$/));

  test('新規対局の検索・選択数・4人未満エラーを確認',async({page})=>{
    await page.goto('user/newgame/date');
    await page.getByRole('button',{name:'対局者選択へ進む'}).click();
    const checks=page.locator('input.ck[name="userNames"]');
    expect(await checks.count(),'同一グループに利用者が必要です').toBeGreaterThan(0);
    await page.locator('input[name="q"]').fill((await checks.first().getAttribute('value')) || '');
    await page.getByRole('button',{name:'検索'}).click();
    await shot(page,'新規対局-ユーザー検索');
    await page.goto('user/newgame/players');
    await page.locator('#checkAll').check();
    await expect(page.locator('#count')).toHaveText(String(await page.locator('input.ck').count()));
    await page.locator('#checkAll').uncheck();
    await page.getByRole('button',{name:'保存して作成'}).click();
    await shot(page,'ポップアップ-新規対局-4人未満');
    await closeAppModal(page);
  });

  test('対局編集の検索・並び順・詳細タブ・行追加を確認',async({page})=>{
    await page.goto('user/matches/edit');
    const searchForm=page.locator('#searchForm');
    const from=searchForm.locator('input[name="from"]'), to=searchForm.locator('input[name="to"]');
    if(await from.count()) { await from.fill('2020-01-01'); await to.fill('2099-12-31'); await searchForm.getByRole('button',{name:'検索'}).click(); }
    const orderInput=searchForm.locator('#orderInput');
    await orderInput.evaluate((e: HTMLInputElement)=>e.value='asc');
    await searchForm.getByRole('button',{name:'検索'}).click();
    await expect(orderInput).toHaveValue('asc');
    await shot(page,'対局編集-検索結果');
    const editLinks=page.getByRole('link',{name:'編集'});
    const editCount=await editLinks.count();
    test.skip(editCount===0,'編集対象データがありません');
    const hrefs:string[]=[];
    for(let i=0;i<editCount;i++){ const href=await editLinks.nth(i).getAttribute('href'); if(href) hrefs.push(href); }
    let detailFound=false;
    for(const href of hrefs){
      await page.goto(href);
      if(await page.locator('.mt-module').count()){ detailFound=true; break; }
    }
    test.skip(!detailFound,'詳細表示できる対局データがありません');
    await expect(page.locator('.mt-module')).toBeVisible();
    await shot(page,'対局編集-詳細-点棒');
    for(const [key,label] of [['rank','順位'],['points','点数']] as const){
      const tab=page.locator(`.mt-module .tab[data-tab="${key}"]`);
      await expect(tab).toBeVisible();
      await tab.click();
      await expect(page.locator(`#mt-pane-${key}`)).toHaveClass(/active/);
      await shot(page,'対局編集-詳細-'+label);
    }
    const before=await page.locator('#mt-pane-score tbody tr').count();
    await page.getByRole('button',{name:'＋ 行を追加'}).click();
    await expect(page.locator('#mt-pane-score tbody tr')).toHaveCount(before+1);
    await shot(page,'対局編集-行追加後');
  });

  test('対局編集の計算エラーと正常計算ポップアップを確認',async({page})=>{
    await page.goto('user/matches/edit');
    const editLinks=page.getByRole('link',{name:'編集'});
    const editCount=await editLinks.count();
    test.skip(editCount===0,'編集対象データがありません');
    const hrefs:string[]=[];
    for(let i=0;i<editCount;i++){ const href=await editLinks.nth(i).getAttribute('href'); if(href) hrefs.push(href); }
    let inputs=page.locator('#mt-pane-score table.mt-score tbody tr').first().locator('td input');
    let found=false;
    for(const href of hrefs){
      await page.goto(href);
      const table=page.locator('#mt-pane-score table.mt-score');
      const attached=await table.waitFor({state:'attached',timeout:1500}).then(()=>true).catch(()=>false);
      if(!attached) continue;
      inputs=table.locator('tbody tr').first().locator('td input');
      if(await inputs.count()===4){ found=true; break; }
    }
    test.skip(!found,'4人の対局編集データがありません');
    for(let i=0;i<4;i++) await inputs.nth(i).fill('');
    await inputs.nth(0).fill('1000');
    await page.getByRole('button',{name:'計算',exact:true}).click();
    await shot(page,'ポップアップ-対局編集-計算エラー');
    await closeAppModal(page);
    for(const [i,v] of ['40000','30000','20000','10000'].entries()) await inputs.nth(i).fill(v);
    await page.getByRole('button',{name:'計算',exact:true}).click();
    await shot(page,'ポップアップ-対局編集-計算完了');
    await closeAppModal(page);
    const rankTab=page.locator('.mt-module .tab[data-tab="rank"]');
    await expect(rankTab).toBeVisible();
    await rankTab.click();
    await expect(page.locator('#mt-pane-rank')).toHaveClass(/active/);
    await expect(page.locator('#mt-pane-rank tbody tr').first().locator('input').nth(0)).toHaveValue('1');
    await shot(page,'対局編集-正常計算結果');
  });

  test('カウンター全入力検証を確認',async({page})=>{
    const cases=[['winCount','和了数は局数以下にしてください。'],['callCount','副露数は局数以下にしてください。'],['riichiCount','立直数は局数以下にしてください。'],['dealInCount','放銃数は局数以下にしてください。']] as const;
    for(const [id,msg] of cases){
      await page.goto('user/counter');
      for(const x of ['handCount','winCount','callCount','riichiCount','dealInCount']) await page.locator('#'+x).evaluate((e:HTMLInputElement)=>e.value='0');
      await page.locator('#handCount').evaluate((e:HTMLInputElement)=>e.value='1');
      await page.locator('#'+id).evaluate((e:HTMLInputElement)=>e.value='2');
      await page.getByRole('button',{name:'登録',exact:true}).click();
      await expect(page.locator('#messageModalText')).toHaveText(msg);
      await shot(page,'ポップアップ-カウンター-'+id);
      await page.locator('#messageModal').getByRole('button',{name:'OK'}).click();
    }
  });

  test('ログアウトして未ログイン保護を確認',async({page})=>{
    await page.getByRole('link',{name:'ログアウト',exact:true}).click();
    await expect(page).toHaveURL(/\/main\/login/);
    await page.goto('user/home');
    await expect(page).toHaveURL(/\/main\/login/);
    await shot(page,'認証-ログアウト後アクセス');
  });
});

test.describe('管理者・詳細機能',()=>{
  test.beforeEach(async({page})=>login(page,adminName,adminPassword,/\/admin\/home$/));

  test('アカウント登録の必須・文字数・確認不一致を確認',async({page})=>{
    await page.goto('account/register');
    await page.locator('form').getByRole('button',{name:'登録'}).click();
    await expect(page.locator('body')).toContainText('名前を入力してください');
    await shot(page,'管理者-アカウント-名前必須');
    await page.locator('input[name="name"]').evaluate((e:HTMLInputElement)=>e.value='12345678901');
    await page.locator('input[name="password"]').fill('abc');
    await page.locator('input[name="passwordConfirm"]').fill('abc');
    await page.locator('form').getByRole('button',{name:'登録'}).click();
    await expect(page.locator('body')).toContainText('名前は10文字以内');
    await shot(page,'管理者-アカウント-名前文字数');
    await page.locator('input[name="name"]').fill('E2E');
    await page.locator('input[name="password"]').fill('abc');
    await page.locator('input[name="passwordConfirm"]').fill('xyz');
    await page.locator('form').getByRole('button',{name:'登録'}).click();
    await expect(page.locator('body')).toContainText('パスワードと確認用が一致しません');
    await shot(page,'管理者-アカウント-確認不一致');
  });

  test('グループ編集の必須・文字数を確認',async({page})=>{
    await page.goto('admin/group/edit');
    await page.locator('input[name="newName"]').fill('');
    await page.getByRole('button',{name:'変更'}).click();
    await expect(page.locator('body')).toContainText('グループ名を入力してください');
    await shot(page,'管理者-グループ-必須');
    await page.locator('input[name="newName"]').evaluate((e:HTMLInputElement)=>e.value='12345678901');
    await page.getByRole('button',{name:'変更'}).click();
    await expect(page.locator('body')).toContainText('グループ名は10文字以内');
    await shot(page,'管理者-グループ-文字数');
  });

  test('管理者から利用者画面へのロール遷移を確認',async({page})=>{
    await page.goto('user/home');
    await expect(page.locator('body')).not.toContainText('Internal Server Error');
    await shot(page,'管理者-利用者ホームアクセス');
  });
});
