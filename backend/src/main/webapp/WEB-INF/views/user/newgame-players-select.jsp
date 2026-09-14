<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="新規対局：対局者選択" active="newgame">
  <div class="wrap">
    <div class="step-label">STEP 2 / 2</div>
    <h2>対局者を選択</h2>
    <p class="game-date">対局日：<strong>${gamedate}</strong></p>

    <form method="get" class="row">
      <input type="text" name="q" value="${query}" placeholder="ユーザ名で検索（部分一致）">
      <button class="btn" type="submit">検索</button>
      <a class="btn" href="${pageContext.request.contextPath}/user/newgame/players">クリア</a>
    </form>

    <form method="post" action="${pageContext.request.contextPath}/user/newgame/players/save" id="selectForm" class="card">
      <div class="toolbar">
        <label><input type="checkbox" id="checkAll"> すべて選択</label>
        <span class="muted">選択数：<span id="count">0</span></span>
      </div>

      <table class="tbl">
        <thead><tr><th style="width:56px">選択</th><th>ユーザ名（利用者のみ）</th></tr></thead>
        <tbody>
        <c:forEach var="name" items="${users}">
          <tr>
            <td><input type="checkbox" class="ck" name="userNames" value="${name}"></td>
            <td>${name}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>

      <div class="actions">
        <a class="btn" href="${pageContext.request.contextPath}/user/newgame/date">日付へ戻る</a>
        <button class="btn btn-primary" type="submit" id="submitBtn">保存して作成</button>
      </div>
    </form>
  </div>

  <style>
    .wrap{max-width:900px;margin:0 auto}
    .step-label{margin-bottom:5px;color:#2e7d32;font-size:.8rem;font-weight:700;letter-spacing:.06em}
    .wrap h2{margin:0;font-size:1.2rem}
    .game-date{margin:5px 0 14px;color:#475569}
    .row{display:grid;grid-template-columns:minmax(180px,1fr) auto auto;gap:8px;margin-bottom:12px}
    .row input{min-width:0;height:44px;padding:8px 11px;border:1px solid #cbd5e1;border-radius:8px;font-size:16px}
    .card{padding:14px;background:#fff;border:1px solid #dfe3e8;border-radius:12px}
    .toolbar{display:flex;justify-content:space-between;align-items:center;min-height:44px;margin-bottom:8px;padding:0 4px}
    .toolbar label{display:flex;align-items:center;gap:7px;font-weight:600}
    .toolbar input,.tbl input{width:20px;height:20px;accent-color:#2e7d32}
    .tbl{width:100%;border-collapse:separate;border-spacing:0}
    .tbl th,.tbl td{padding:11px 9px;border-bottom:1px solid #e5e7eb;text-align:left}
    .tbl th{background:#e8f5e9;color:#1f4322}
    .tbl tr:nth-child(even) td{background:#f8fafc}
    .tbl td:first-child{text-align:center}
    .btn{display:inline-flex;min-height:44px;align-items:center;justify-content:center;padding:8px 13px;border:1px solid #cbd5e1;border-radius:8px;background:#fff;color:#334155;text-decoration:none;cursor:pointer;font-weight:600}
    .btn-primary{background:#2e7d32;border-color:#2e7d32;color:#fff}
    .actions{display:flex;justify-content:flex-end;gap:9px;margin-top:14px}
    .muted{color:#64748b}
    @media(max-width:760px){
      .wrap h2{font-size:1.1rem}
      .row{grid-template-columns:1fr 1fr}
      .row input{grid-column:1/-1}
      .card{padding:10px 8px}
      .actions{display:grid;grid-template-columns:1fr 1fr}
      .actions .btn{width:100%}
    }
  </style>

  <script>
    (function(){
      const checks = () => Array.from(document.querySelectorAll('.ck'));
      const countEl = document.getElementById('count');
      const update = () => countEl.textContent = checks().filter(c=>c.checked).length;
      document.getElementById('checkAll').addEventListener('change', e=>{
        checks().forEach(c=> c.checked = e.target.checked); update();
      });
      document.getElementById('selectForm').addEventListener('change', e=>{
        if(e.target.classList.contains('ck')) update();
      });
      update();
      document.getElementById('selectForm').addEventListener('submit', e=>{
        const n = checks().filter(c=>c.checked).length;
        if(n < 4){
          e.preventDefault();
          alert('最低4人を選択してください。');
        }
      });
    })();
  </script>
</u:layout>
