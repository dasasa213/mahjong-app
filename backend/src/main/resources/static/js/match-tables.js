// ===== match-tables.js (full) =====
(function (global) {
  'use strict';

  const toNum = (v) => {
    if (v === null || v === undefined) return NaN;
    const s = String(v).replace(/[, ]/g, '');
    if (s === '') return NaN;
    return Number(s);
  };
  const isBlank = (v) => v === '' || v === null || v === undefined;

  class MatchTablesApp {
    constructor(opts) {
      this.container = document.getElementById(opts.mount.containerId);
      if (!this.container) throw new Error('container not found: ' + opts.mount.containerId);
      this.panes = opts.mount.panes;
      this.initialRows = Number(opts.mount.initialRows || 4);
      this.addRowBtnId = opts.mount.addRowBtnId;
      this.players = Array.isArray(opts.players) ? opts.players : [];
      this.calcBtnId = opts.buttons?.calcBtnId || '';
      this.saveBtnId = opts.buttons?.saveBtnId || '';
    }

    build() {
      // タブ切り替え
      this._wireTabs();

      // 各テーブル組み立て
      this._buildScoreTable();
      this._buildRankTable();
      this._buildPointsTable();

      // 行追加
      const addBtn = document.getElementById(this.addRowBtnId);
      if (addBtn) addBtn.addEventListener('click', () => this.addOneRow());

      // 計算ボタン
      if (this.calcBtnId) {
        const btn = document.getElementById(this.calcBtnId);
        if (btn) btn.addEventListener('click', () => this.calculateAll());
      }
    }

    _wireTabs() {
      const tabs = this.container.querySelectorAll('.tab');
      const panes = this.container.querySelectorAll('.pane');
      tabs.forEach(tab => {
        tab.addEventListener('click', () => {
          tabs.forEach(t => t.classList.remove('active'));
          panes.forEach(p => p.classList.remove('active'));
          tab.classList.add('active');
          const key = tab.getAttribute('data-tab');
          const id  = this.panes[key];
          document.getElementById(id)?.classList.add('active');
        });
      });
    }

    _buildScoreTable() {
      const pane = document.getElementById(this.panes.score);
      pane.innerHTML = '';
      const tbl = document.createElement('table');
      tbl.className = 'mt-table mt-score';
      tbl.innerHTML = this._tableHeaderHtml('点棒') +
                      `<tbody>${this._scoreBodyRowsHtml(this.initialRows)}</tbody>`;
      pane.appendChild(tbl);
      this.scoreTable = tbl;
    }

    _buildRankTable() {
      const pane = document.getElementById(this.panes.rank);
      pane.innerHTML = '';
      const tbl = document.createElement('table');
      tbl.className = 'mt-table mt-rank';
      tbl.innerHTML = this._tableHeaderHtml('順位') +
        `<tbody>${this._rankBodyRowsHtml(this.initialRows)}</tbody>` +
        this._rankFooterHtml();
      pane.appendChild(tbl);
      this.rankTable = tbl;
    }

    _buildPointsTable() {
      const pane = document.getElementById(this.panes.points);
      pane.innerHTML = '';
      const tbl = document.createElement('table');
      tbl.className = 'mt-table mt-points';
      tbl.innerHTML = this._tableHeaderHtml('点数') +
        `<tbody>${this._pointsBodyRowsHtml(this.initialRows)}</tbody>` +
        this._pointsFooterHtml();
      pane.appendChild(tbl);
      this.pointsTable = tbl;
    }

    _tableHeaderHtml(firstColTitle) {
      const ths = this.players.map(p => `<th>${escapeHtml(p)}</th>`).join('');
      return `<thead><tr><th style="width:72px">${firstColTitle}</th>${ths}</tr></thead>`;
    }

    _scoreBodyRowsHtml(n) {
      const tds = this.players.map(() => `<td><input type="text" inputmode="numeric" /></td>`).join('');
      let html = '';
      for (let i = 1; i <= n; i++) {
        html += `<tr data-row="${i}"><td class="headcol">${i}</td>${tds}</tr>`;
      }
      return html;
    }

    _rankBodyRowsHtml(n) {
      const tds = this.players.map(() => `<td><input type="text" inputmode="numeric" /></td>`).join('');
      let html = '';
      for (let i = 1; i <= n; i++) {
        html += `<tr data-row="${i}"><td class="headcol">${i}</td>${tds}</tr>`;
      }
      return html;
    }

    _pointsBodyRowsHtml(n) {
      const tds = this.players.map(() => `<td><input type="text" inputmode="decimal" /></td>`).join('');
      let html = '';
      for (let i = 1; i <= n; i++) {
        html += `<tr data-row="${i}"><td class="headcol">${i}</td>${tds}</tr>`;
      }
      return html;
    }

    _rankFooterHtml() {
      const cols = this.players.length;
      const row = (label) => {
        let cells = '';
        for (let i = 0; i < cols; i++) cells += `<td><input type="text" readonly /></td>`;
        return `<tr class="summary"><td class="headcol">${label}</td>${cells}</tr>`;
      };
      return `<tfoot>
        ${row('平均')}
        ${row('1位')}
        ${row('2位')}
        ${row('3位')}
        ${row('4位')}
      </tfoot>`;
    }

    _pointsFooterHtml() {
      const cols = this.players.length;
      const row = (label) => {
        let cells = '';
        for (let i = 0; i < cols; i++) cells += `<td><input type="text" readonly /></td>`;
        return `<tr class="summary"><td class="headcol">${label}</td>${cells}</tr>`;
      };
      return `<tfoot>
        ${row('合計')}
        ${row('ペソ')}
      </tfoot>`;
    }

    addOneRow() {
      const mk = (cellsHtml, tbl) => {
        const tbody = tbl.tBodies[0];
        const idx = tbody.rows.length + 1;
        const tr = document.createElement('tr');
        tr.setAttribute('data-row', String(idx));
        tr.innerHTML = `<td class="headcol">${idx}</td>${cellsHtml}`;
        tbody.appendChild(tr);
      };
      // score
      mk(this.players.map(() => `<td><input type="text" inputmode="numeric" /></td>`).join(''), this.scoreTable);
      // rank
      mk(this.players.map(() => `<td><input type="text" inputmode="numeric" /></td>`).join(''), this.rankTable);
      // points
      mk(this.players.map(() => `<td><input type="text" inputmode="decimal" /></td>`).join(''), this.pointsTable);
    }

    calculateAll() {
      // ヘッダ（配点/返し点/ウマ/レート）
      const cfg = readHeaderConfig();
      // 点棒行を読み込み（空行はスキップ）
      const rows = this._readScoreRows();

      // まずリセット（エラー色・出力）
      this._clearRowStates();
      this._clearOutputs();

      // 行ごとに検証 & 計算
      const validRows = [];
      rows.forEach(r => {
        const { rowIndex, values } = r;            // values: {col:number -> score:number}
        // 未入力列を除外した有効セル
        const entries = Object.entries(values).filter(([, v]) => !Number.isNaN(v));
        if (entries.length === 0) return;          // ★空行はスキップ
        // ちょうど4セル？
        if (entries.length !== 4) {
          this._markError(this.scoreTable, rowIndex);
          return;
        }
        // 合計10万？
        const total = entries.reduce((s, [, v]) => s + v, 0);
        if (total !== 100000) {
          this._markError(this.scoreTable, rowIndex);
          return;
        }
        validRows.push(r);
      });

      // 有効行に対して順位→点数→集計反映
      const ranksByRow = new Map();  // rowIndex -> {col -> rank}
      validRows.forEach(r => {
        const ranks = calcRanks(r.values);               // 未入力列は rank 付与しない
        ranksByRow.set(r.rowIndex, ranks);
        // 順位表へ反映
        this._writeRanks(r.rowIndex, ranks);
        // 点数表へ反映
        this._writePoints(r.rowIndex, r.values, ranks, cfg);
      });

      // フッターの集計
      this._writeRankSummary(ranksByRow);
      this._writePointsSummary();
    }

    _readScoreRows() {
      const out = [];
      const tbody = this.scoreTable.tBodies[0];
      Array.from(tbody.rows).forEach((tr, rIdx) => {
        const values = {};
        Array.from(tr.cells).forEach((td, cIdx) => {
          if (cIdx === 0) return;
          const v = toNum(td.querySelector('input').value);
          if (!Number.isNaN(v)) values[cIdx - 1] = v; // 0-based col
        });
        out.push({ rowIndex: rIdx, values });
      });
      return out;
    }

    _markError(table, rowIndex) {
      const tr = table.tBodies[0].rows[rowIndex];
      if (tr) tr.classList.add('mt-row-error');
    }

    _clearRowStates() {
      [this.scoreTable, this.rankTable, this.pointsTable].forEach(tbl => {
        Array.from(tbl.tBodies[0].rows).forEach(tr => tr.classList.remove('mt-row-error'));
      });
    }

    _clearOutputs() {
      // rank / points 全クリア（readonly含む）
      const clearTbl = (tbl) => {
        Array.from(tbl.tBodies[0].querySelectorAll('input')).forEach(i => i.value = '');
        Array.from(tbl.tFoot?.querySelectorAll('input') || []).forEach(i => i.value = '0.00');
      };
      clearTbl(this.rankTable);
      clearTbl(this.pointsTable);
    }

    _writeRanks(rowIndex, ranks) {
      const tr = this.rankTable.tBodies[0].rows[rowIndex];
      if (!tr) return;
      Object.entries(ranks).forEach(([col, rank]) => {
        const td = tr.cells[Number(col) + 1]; // +1: 先頭の「順位」列
        td.querySelector('input').value = String(rank);
      });
    }

    _writePoints(rowIndex, scores, ranks, cfg) {
      const tr = this.pointsTable.tBodies[0].rows[rowIndex];
      if (!tr) return;
      // 対象列のみ計算
      Object.entries(scores).forEach(([colStr, rawScore]) => {
        const col = Number(colStr);
        const rank = ranks[col];
        if (!rank) return; // ランクがない=未入力扱い
        const base = cfg.points;         // 配点
        const ret  = cfg.returnpoints;   // 返し点

        let val = (rawScore - ret) / 1000;
        // Uma
        if (rank === 1) val += cfg.uma1;
        else if (rank === 2) val += cfg.uma2;
        else if (rank === 3) val -= cfg.uma2;
        else if (rank === 4) val -= cfg.uma1;
        // Oka (トップにのみ)
        if (rank === 1) val += ((ret - base) / 1000) * 4;

        const td = tr.cells[col + 1];
        td.querySelector('input').value = val.toFixed(2);
      });
    }

    _writeRankSummary(ranksByRow) {
      // 列ごとの [順位配列]
      const colRanks = Array.from(this.players, () => []);
      ranksByRow.forEach((ranks) => {
        Object.entries(ranks).forEach(([colStr, rank]) => {
          colRanks[Number(colStr)].push(rank);
        });
      });

      const tfoot = this.rankTable.tFoot;
      if (!tfoot) return;

      const rows = Array.from(tfoot.rows); // [平均,1位,2位,3位,4位]
      const avgRow = rows[0];
      const cntRow = [rows[1], rows[2], rows[3], rows[4]];

      colRanks.forEach((arr, col) => {
        if (arr.length === 0) {
          avgRow.cells[col + 1].querySelector('input').value = '0.00';
          for (let i = 0; i < 4; i++) cntRow[i].cells[col + 1].querySelector('input').value = '0.00';
          return;
        }
        const avg = arr.reduce((s, v) => s + v, 0) / arr.length;
        avgRow.cells[col + 1].querySelector('input').value = avg.toFixed(2);
        for (let r = 1; r <= 4; r++) {
          const pct = (arr.filter(v => v === r).length / arr.length) * 100;
          cntRow[r - 1].cells[col + 1].querySelector('input').value = pct.toFixed(2);
        }
      });
    }

    _writePointsSummary() {
      const tfoot = this.pointsTable.tFoot;
      if (!tfoot) return;
      const sumRow  = tfoot.rows[0];
      const pesoRow = tfoot.rows[1];

      const cols = this.players.length;
      for (let c = 0; c < cols; c++) {
        let sum = 0;
        Array.from(this.pointsTable.tBodies[0].rows).forEach(tr => {
          const v = toNum(tr.cells[c + 1].querySelector('input').value);
          if (!Number.isNaN(v)) sum += v;
        });
        sumRow.cells[c + 1].querySelector('input').value = sum.toFixed(2);

        const rate = toNum(document.querySelector('input[name="rate"]')?.value || 0);
        const peso = sum * (Number.isNaN(rate) ? 0 : rate);
        pesoRow.cells[c + 1].querySelector('input').value = peso.toFixed(2);
      }
    }
  }

  // ============ helpers ============
  function readHeaderConfig() {
    const q = (name) => toNum(document.querySelector(`input[name="${name}"]`)?.value);
    return {
      points:       q('points'),        // 配点
      returnpoints: q('returnpoints'),  // 返し点
      uma1:         q('uma1'),
      uma2:         q('uma2')
    };
  }

  function calcRanks(scoreMap) {
    // scoreMap: {col -> score}
    const entries = Object.entries(scoreMap).map(([c, v]) => ({ col: Number(c), val: v }));
    // 降順
    entries.sort((a, b) => b.val - a.val);
    const ranks = {};
    for (let i = 0; i < entries.length; i++) {
      ranks[entries[i].col] = i + 1; // 同点は後勝ちで素直に 1,2,3,4 を振る
    }
    return ranks;
  }

  function escapeHtml(s) {
    return String(s)
      .replaceAll('&','&amp;').replaceAll('<','&lt;')
      .replaceAll('>','&gt;').replaceAll('"','&quot;').replaceAll("'",'&#39;');
  }

  // ============ public API ============
  global.matchTables = {
    init(opts) {
      const app = new MatchTablesApp(opts);
      app.build();
      return app;
    }
  };

})(window);
