// /static/js/mt-submit.js
(function () {
  'use strict';

  // 数値に寄せる（空は null）
  const toNum = (v) => {
    if (v == null) return null;
    const s = String(v).replace(/[, ]/g, '');
    if (s === '') return null;
    const n = Number(s);
    return Number.isNaN(n) ? null : n;
  };

  // ヘッダの拾い出し（name属性ベース）
  function readHeader() {
    const q = (name) => document.querySelector(`input[name="${name}"]`);
    return {
      // ← SaveTablesRequest.Header に合わせる（gamedate は "yyyy-MM-dd" 文字列でOK）
      gamedate:      q('gamedate')?.value || null,
      gameno:        toNum(q('gameno')?.value),
      rate:          toNum(q('rate')?.value),
      points:        toNum(q('points')?.value),
      returnpoints:  toNum(q('returnpoints')?.value),
      uma1:          toNum(q('uma1')?.value),
      uma2:          toNum(q('uma2')?.value)
    };
  }

  // 1テーブルから rows[] を作る
  function readRowsFromTable(tableEl, players) {
    const out = [];
    const tbody = tableEl?.tBodies?.[0];
    if (!tbody) return out;
    const trs = Array.from(tbody.rows); // <tr data-row="1">…
    trs.forEach(tr => {
      const rowNum = Number(tr.getAttribute('data-row')); // 1-based
      for (let pi = 0; pi < players.length; pi++) {
        const input = tr.cells[pi + 1]?.querySelector('input'); // 先頭は見出し列
        if (!input) continue;
        const raw = input.value;
        if (raw == null || raw === '') continue; // 空は送らない
        out.push({
          row_num: rowNum,
          name: players[pi],
          value: toNum(raw)
        });
      }
    });
    return out;
  }

  // 送信用オブジェクト（SaveTablesRequest と同形）
  function buildSaveTablesRequest(players) {
    const scoreTbl  = document.querySelector('#mt-pane-score  table.mt-score');
    const rankTbl   = document.querySelector('#mt-pane-rank   table.mt-rank');
    const pointsTbl = document.querySelector('#mt-pane-points table.mt-points');
    return {
      header:   readHeader(),
      scores:   readRowsFromTable(scoreTbl,  players),
      rankings: readRowsFromTable(rankTbl,   players),
      points:   readRowsFromTable(pointsTbl, players),
      gameId:   document.querySelector('input[name="id"]')?.value || null
    };
  }

  window.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('editForm');
    const saveBtn = document.getElementById('saveBtn');
    if (!form || !saveBtn) return;

    // players は matchTables.tag が container の data-players に埋めている
    const container = document.getElementById('mt-container');
    const players = container ? JSON.parse(container.getAttribute('data-players')) : [];

    saveBtn.addEventListener('click', function () {
      // 組み立て → hidden にセット → submit
      const payload = buildSaveTablesRequest(players);
      document.getElementById('savePayload').value = JSON.stringify(payload);
      console.log('payload', payload)
      form.submit();
    });
  });
})();
