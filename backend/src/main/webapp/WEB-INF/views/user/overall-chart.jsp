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
          <option value="avgRank" ${defaultMetric == 'avgRank' ? 'selected' : ''}>平均順位（累積）</option>
        </select>
      </label>

      <button id="reloadBtn" class="btn primary" type="button">更新</button>
    </div>

    <div class="chart-area">
      <canvas id="overallChart"></canvas>
    </div>
  </section>

  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.6/dist/chart.umd.min.js"></script>
  <script>
    (function(){
      const $user = document.getElementById('userSelect');
      const $metric = document.getElementById('metricSelect');
      const $btn = document.getElementById('reloadBtn');
      const ctx = document.getElementById('overallChart').getContext('2d');
      let chart;

      function seriesLabel(metric){
        switch(metric){
          case 'amount': return '累積：合計金額';
          case 'avgRank': return '累積：平均順位';
          default: return '累積：合計点数';
        }
      }

      function buildOptions(metric){
        const isAvg = metric === 'avgRank';
        const y = {
          beginAtZero: !isAvg,
          title: { display: true, text: isAvg ? '平均順位' : (metric === 'amount' ? '金額' : '点数') }
        };
        if(isAvg){ y.min = 1; y.max = 4; }
        return {
          responsive: true,
          maintainAspectRatio: false,
          interaction: { mode: 'index', intersect: false },
          scales: {
            x: { title: { display: true, text: '対局日' } },
            y
          },
          plugins: { legend: { display: true, labels: { usePointStyle: true } } }
        };
      }

      async function loadAndRender(){
        $btn.disabled = true;
        $btn.textContent = '読込中…';
        try {
          const params = new URLSearchParams({ userName: $user.value, metric: $metric.value });
          const res = await fetch('<c:url value="/user/overall/chart/data"/>' + '?' + params.toString(),
                                  { headers: { 'Accept': 'application/json' }});
          if(!res.ok) throw new Error('グラフデータを取得できませんでした');
          const data = await res.json();
          const cfg = {
            type: 'line',
            data: {
              labels: data.labels || [],
              datasets: [{
                label: seriesLabel(data.metric),
                data: data.series || [],
                tension: .25,
                pointRadius: 2,
                pointHitRadius: 12,
                borderWidth: 2,
                borderColor: '#2e7d32',
                backgroundColor: 'rgba(46,125,50,.12)'
              }]
            },
            options: buildOptions(data.metric)
          };
          if(chart) chart.destroy();
          chart = new Chart(ctx, cfg);
        } catch(error) {
          alert(error.message);
        } finally {
          $btn.disabled = false;
          $btn.textContent = '更新';
        }
      }

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
    .controls{display:grid;grid-template-columns:minmax(180px,1fr) minmax(220px,1.4fr) auto;align-items:end;gap:12px;padding:16px;background:#f8fafc}
    .control-field{display:flex;flex-direction:column;gap:5px;color:#475569;font-size:.9rem;font-weight:600}
    .input{width:100%;min-height:44px;padding:8px 10px;border:1px solid #cbd5e1;border-radius:8px;background:#fff;font-size:16px}
    .input:focus{outline:3px solid rgba(37,99,235,.18);border-color:#2563eb}
    .btn{min-width:100px;min-height:44px;padding:8px 14px;border:1px solid #1976d2;border-radius:8px;cursor:pointer;font-weight:700}
    .btn.primary{background:#1976d2;color:#fff}
    .btn:disabled{opacity:.65;cursor:wait}
    .chart-area{height:min(58vh,520px);min-height:360px;padding:18px}
    @media(max-width:768px){
      .chart-card{border-radius:10px}
      .chart-heading{align-items:flex-start;flex-direction:column;padding:12px}
      .controls{grid-template-columns:1fr;padding:12px}
      .btn{width:100%}
      .chart-area{height:52vh;min-height:320px;padding:10px 6px}
    }
  </style>
</u:layout>
