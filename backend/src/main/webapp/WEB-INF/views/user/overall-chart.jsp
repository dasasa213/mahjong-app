<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="総合成績（グラフ）" active="${active}">
  <div class="container" style="padding:16px;">
    <div class="controls" style="display:flex; gap:12px; flex-wrap:wrap; align-items:end;">
      <div>
        <label for="userSelect">対象者</label><br/>
        <select id="userSelect" class="input" style="min-width:220px;">
          <c:forEach var="nm" items="${users}">
            <option value="${nm}" ${nm == defaultUserName ? 'selected' : ''}>${nm}</option>
          </c:forEach>
        </select>
      </div>

      <div>
        <label for="metricSelect">対象データ</label><br/>
        <select id="metricSelect" class="input">
          <option value="point"   ${defaultMetric == 'point'   ? 'selected' : ''}>合計点数（累積）</option>
          <option value="amount"  ${defaultMetric == 'amount'  ? 'selected' : ''}>合計金額（累積）</option>
          <option value="avgRank" ${defaultMetric == 'avgRank' ? 'selected' : ''}>平均順位（累積）</option>
        </select>
      </div>

      <div>
        <button id="reloadBtn" class="btn primary" type="button">更新</button>
      </div>
    </div>

    <div style="margin-top:16px; height:420px;">
      <canvas id="overallChart"></canvas>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.6/dist/chart.umd.min.js"></script>

  <script>
    (function(){
      const $user   = document.getElementById('userSelect');
      const $metric = document.getElementById('metricSelect');
      const $btn    = document.getElementById('reloadBtn');
      const ctx     = document.getElementById('overallChart').getContext('2d');
      let chart;

      function seriesLabel(metric){
        switch(metric){
          case 'amount':  return '累積：合計金額';
          case 'avgRank': return '累積：平均順位';
          default:        return '累積：合計点数';
        }
      }

      function buildOptions(metric){
        const isAvg = metric === 'avgRank';
        const y = {
          beginAtZero: !isAvg,
          title: { display: true, text: isAvg ? '平均順位' : (metric === 'amount' ? '金額' : '点数') }
        };
        if (isAvg) { y.min = 1; y.max = 4; }  // 1〜4位の範囲に合わせる
        return {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            x: { title: { display: true, text: '対局日' } },
            y
          },
          plugins: { legend: { display: true } }
        };
      }

      async function loadAndRender(){
        const params = new URLSearchParams({ userName: $user.value, metric: $metric.value });
        const res = await fetch('<c:url value="/user/overall/chart/data"/>' + '?' + params.toString(), { headers: { 'Accept': 'application/json' }});
        const data = await res.json();

        const cfg = {
          type: 'line',
          data: {
            labels: data.labels || [],
            datasets: [{
              label: seriesLabel(data.metric),
              data: data.series || [],
              tension: 0.25,
              pointRadius: 2,
              borderWidth: 2
            }]
          },
          options: buildOptions(data.metric)
        };
        if (chart) chart.destroy();
        chart = new Chart(ctx, cfg);
      }

      $btn.addEventListener('click', loadAndRender);
      loadAndRender(); // 初期表示
    })();
  </script>

  <style>
    .btn { padding: 8px 14px; border: 1px solid #888; background: #fff; border-radius: 10px; cursor: pointer; }
    .btn.primary { background: #1967d2; color: #fff; border-color: #1967d2; }
    .input { padding: 6px 8px; border: 1px solid #ccc; border-radius: 8px; min-height: 36px; }
  </style>
</u:layout>
