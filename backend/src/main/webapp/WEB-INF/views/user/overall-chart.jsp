<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="総合成績（グラフ）" active="${active}">
  <section class="chart-card" aria-labelledby="chart-title">
    <div class="chart-heading">
      <h2 id="chart-title">成績推移</h2>
      <span>対象者とデータを選択して表示します</span>
    </div>

    <div class="controls">
      <label class="control-field" for="userSelect">
        <span>対象者</span>
        <select id="userSelect" class="input">
          <c:forEach var="nm" items="${users}">
            <option value="${nm}" ${nm == defaultUserName ? 'selected' : ''}>${nm}</option>
          </c:forEach>
        </select>
      </label>

      <label class="control-field" for="metricSelect">
        <span>対象データ</span>
        <select id="metricSelect" class="input">
          <option value="point" ${defaultMetric == 'point' ? 'selected' : ''}>合計点数（累積）</option>
          <option value="amount" ${defaultMetric == 'amount' ? 'selected' : ''}>合計金額（累積）</option>
          <option value="avgRank" ${defaultMetric == 'avgRank' ? 'selected' : ''}>平均順位（移動平均）</option>
        </select>
      </label>

      <label id="rankScaleControl" class="control-field rank-scale" for="rankScaleSelect" hidden>
        <span>平均順位の縦軸</span>
        <select id="rankScaleSelect" class="input">
          <option value="auto" selected>自動（データに合わせる）</option>
          <option value="fixed">固定（1.5〜3.5）</option>
        </select>
      </label>

      <button id="reloadBtn" class="btn primary" type="button">更新</button>
    </div>

    <p id="rankHint" class="rank-hint" hidden>平均順位は半荘ごとに表示します。25・50・100半荘の移動平均線は、それぞれ必要な半荘数に達してから表示します。凡例を押すと線の表示を切り替えられます。縦軸の「自動」は表示中の線に合わせて調整します。プレイヤー同士を同じ目盛りで比べる場合は「固定」を選んでください。</p>
    <div id="chartArea" class="chart-area">
      <canvas id="overallChart"></canvas>
    </div>
  </section>

  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.6/dist/chart.umd.min.js"></script>
  <script>
    (function(){
      const $user = document.getElementById('userSelect');
      const $metric = document.getElementById('metricSelect');
      const $scale = document.getElementById('rankScaleSelect');
      const $scaleControl = document.getElementById('rankScaleControl');
      const $area = document.getElementById('chartArea');
      const $btn = document.getElementById('reloadBtn');
      const ctx = document.getElementById('overallChart').getContext('2d');
      let chart;
      let requestNumber = 0;

      function seriesLabel(metric){
        switch(metric){
          case 'amount': return '累積：合計金額';
          case 'avgRank': return '累積：平均順位';
          default: return '累積：合計点数';
        }
      }

      function rankBounds(datasets) {
        if ($scale.value === 'fixed') return { min: 1.5, max: 3.5 };
        let low = Infinity, high = -Infinity;
        datasets.forEach(function(dataset) {
          (dataset.data || []).forEach(function(value) {
            if (typeof value === 'number' && Number.isFinite(value)) {
              low = Math.min(low, value);
              high = Math.max(high, value);
            }
          });
        });
        if (!Number.isFinite(low)) return { min: 1.5, max: 3.5 };
        // Keep a minimum half-range before clamping to valid ranks (1 to 4).
        const center = (low + high) / 2;
        const halfRange = Math.max(0.2, (high - low) / 2 + 0.1);
        return {
          min: Math.max(1, Math.floor((center - halfRange) * 10) / 10),
          max: Math.min(4, Math.ceil((center + halfRange) * 10) / 10)
        };
      }

      function updateRankScale() {
        if (!chart || $scaleControl.hidden) return;
        const visible = chart.data.datasets.filter(function(dataset, index) {
          return chart.isDatasetVisible(index);
        });
        Object.assign(chart.options.scales.y, rankBounds(visible));
        chart.update();
      }

      function buildOptions(metric, datasets){
        const isAvg = metric === 'avgRank';
        const y = {
          beginAtZero: !isAvg,
          title: { display: true, text: isAvg ? '平均順位' : (metric === 'amount' ? '金額' : '点数') }
        };
        if(isAvg){ Object.assign(y, rankBounds(datasets)); }
        return {
          responsive: true,
          maintainAspectRatio: false,
          interaction: { mode: 'index', intersect: false },
          scales: {
            x: { title: { display: true, text: isAvg ? '対局日・通算半荘数' : '対局日' } },
            y
          },
          plugins: { legend: {
            display: true, labels: { usePointStyle: true },
            onClick: function(event, item, legend) {
              Chart.defaults.plugins.legend.onClick.call(this, event, item, legend);
              if (isAvg) updateRankScale();
            }
          } }
        };
      }

      async function loadAndRender(){
        const request = ++requestNumber;
        $btn.disabled = true;
        $btn.textContent = '読込中…';
        try {
          const params = new URLSearchParams({ userName: $user.value, metric: $metric.value });
          const res = await fetch('<c:url value="/user/overall/chart/data"/>' + '?' + params.toString(),
                                  { headers: { 'Accept': 'application/json' }});
          if(!res.ok) throw new Error('グラフデータを取得できませんでした');
          const data = await res.json();
          if (request !== requestNumber) return;
          document.getElementById('rankHint').hidden = data.metric !== 'avgRank';
          $scaleControl.hidden = data.metric !== 'avgRank';
          $area.classList.toggle('rank-chart', data.metric === 'avgRank');
          const cumulativeDataset = {
            label: seriesLabel(data.metric), data: data.series || [],
            tension: data.metric === 'avgRank' ? 0 : .25, pointRadius: 2, pointHitRadius: 12, borderWidth: 2,
            borderColor: '#2e7d32', backgroundColor: 'rgba(46,125,50,.12)'
          };
          const datasets = [];
          if (data.metric !== 'avgRank') {
            datasets.push(cumulativeDataset);
          }
          if (data.metric === 'avgRank') {
            // 累積平均順位は非表示。再表示する場合は次の行のコメントを解除する。
            // datasets.push(cumulativeDataset);
            const styles = [
              { window: 25, color: '#2563eb', dash: [] },
              { window: 50, color: '#d97706', dash: [6, 3] },
              { window: 100, color: '#9333ea', dash: [2, 3] }
            ];
            styles.forEach(function(style) {
              const values = (data.movingAverages || {})[String(style.window)] || [];
              if (!values.some(function(value) { return value !== null; })) return;
              datasets.push({
                label: '直近' + style.window + '半荘平均', data: values,
                borderColor: style.color, backgroundColor: style.color,
                borderDash: style.dash, borderWidth: 2, tension: 0,
                pointRadius: 0, pointHoverRadius: 4, pointHitRadius: 12, spanGaps: false
              });
            });
          }
          const cfg = {
            type: 'line',
            data: {
              labels: data.labels || [],
              datasets: datasets
            },
            options: buildOptions(data.metric, datasets)
          };
          if(chart) chart.destroy();
          chart = new Chart(ctx, cfg);
        } catch(error) {
          if (request === requestNumber) showAppMessage(error.message, 'グラフ表示エラー');
        } finally {
          if (request === requestNumber) {
            $btn.disabled = false;
            $btn.textContent = '更新';
          }
        }
      }

      $scale.addEventListener('change', updateRankScale);
      $btn.addEventListener('click', loadAndRender);
      $user.addEventListener('change', loadAndRender);
      $metric.addEventListener('change', loadAndRender);
      loadAndRender();
    })();
  </script>

  <style>
    .chart-card{background:#fff;border:1px solid #dfe3e8;border-radius:12px;overflow:hidden}
    .chart-heading{display:flex;align-items:baseline;justify-content:space-between;gap:12px;padding:14px 16px;border-bottom:1px solid #e5e7eb}
    .chart-heading h2{margin:0;font-size:1.05rem}
    .chart-heading span{color:#64748b;font-size:.85rem}
    .controls{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));align-items:end;gap:12px;padding:16px;background:#f8fafc}
    .control-field{display:flex;flex-direction:column;gap:5px;color:#475569;font-size:.9rem;font-weight:600}
    .rank-scale[hidden]{display:none}
    .input{width:100%;min-height:44px;padding:8px 10px;border:1px solid #cbd5e1;border-radius:8px;background:#fff;font-size:16px}
    .input:focus{outline:3px solid rgba(37,99,235,.18);border-color:#2563eb}
    .btn{min-width:100px;min-height:44px;padding:8px 14px;border:1px solid #1976d2;border-radius:8px;cursor:pointer;font-weight:700}
    .btn.primary{background:#1976d2;color:#fff}
    .btn:disabled{opacity:.65;cursor:wait}
    .rank-hint{margin:12px 16px;color:#475569;font-size:13px;line-height:1.6}
    .chart-area{height:min(58vh,520px);min-height:360px;padding:18px}
    .chart-area.rank-chart{height:min(80vh,780px);min-height:540px}
    @media(max-width:768px){
      .chart-card{border-radius:10px}
      .chart-heading{align-items:flex-start;flex-direction:column;padding:12px}
      .controls{grid-template-columns:1fr;padding:12px}
      .btn{width:100%}
      .chart-area{height:52vh;min-height:320px;padding:10px 6px}
      .chart-area.rank-chart{height:70vh;min-height:420px}
    }
  </style>
</u:layout>
