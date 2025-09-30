<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="新規対局：対局者選択" active="newgame">
  <div class="wrap">
    <h2>対局者を選択（対局日：${gamedate}）</h2>

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
    .wrap{max-width:900px;margin:16px auto;padding:0 12px}
    .row{display:flex;gap:8px;margin:8px 0}
    .card{background:#fff;border:1px solid #e5e7eb;border-radius:12px;padding:12px}
    .toolbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px}
    .tbl{width:100%;border-collapse:collapse}
    .tbl th,.tbl td{border-bottom:1px solid #eee;padding:8px 6px;text-align:left}
    .btn{padding:8px 12px;border:1px solid #d1d5db;border-radius:10px;background:#f9fafb;text-decoration:none;cursor:pointer}
    .btn-primary{background:#2563eb;border-color:#2563eb;color:#fff}
    .actions{display:flex;gap:8px;margin-top:10px}
    .muted{color:#6b7280}
    @media (max-width:760px){.row{flex-direction:column}.actions{flex-direction:column}}
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
