<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="対局編集" active="${active}">

  <c:if test="${not empty success}">
    <div class="alert success" role="status">${success}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert error" role="alert">${error}</div>
  </c:if>

  <section class="search-card" aria-labelledby="search-title">
    <h2 id="search-title">検索条件</h2>
    <form id="searchForm" method="get"
          action="${pageContext.request.contextPath}/user/matches/edit"
          class="search-form">
      <label class="date-field">
        <span>開始日</span>
        <input type="date" name="from" value="${from}" required />
      </label>
      <span class="tilde" aria-hidden="true">～</span>
      <label class="date-field">
        <span>終了日</span>
        <input type="date" name="to" value="${to}" required />
      </label>

      <input type="hidden" name="order" id="orderInput" value="${order}" />

      <button type="submit" class="btn primary search-btn">検索</button>

      <div class="toggle">
        <span>古い順</span>
        <label class="switch">
          <input type="checkbox" id="orderToggle"
                 aria-label="新しい順に並べる"
                 <c:if test="${order == 'desc'}">checked</c:if> />
          <span class="slider"></span>
        </label>
        <span>新しい順</span>
      </div>
    </form>
  </section>

  <section class="list-card" aria-labelledby="list-title">
    <div class="list-heading">
      <h2 id="list-title">対局一覧</h2>
      <span class="swipe-hint">横にスワイプして詳細を表示できます</span>
    </div>

    <div class="list-wrap" tabindex="0">
      <table class="list">
        <thead>
        <tr>
          <th>ID</th>
          <th>対局日</th>
          <th>回</th>
          <th>レート</th>
          <th>持ち点</th>
          <th>返し点</th>
          <th>ウマ1</th>
          <th>ウマ2</th>
          <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="r" items="${records}">
          <tr>
            <td>${r.id}</td>
            <td><c:out value="${r.gamedate}"/></td>
            <td>${r.gameno}</td>
            <td>${r.rate}</td>
            <td>${r.points}</td>
            <td>${r.returnpoints}</td>
            <td><c:out value="${r.uma1}"/></td>
            <td><c:out value="${r.uma2}"/></td>
            <td class="ops">
              <a class="btn edit" href="${pageContext.request.contextPath}/user/matches/edit/${r.id}">編集</a>
              <button type="button" class="btn danger"
                      data-id="${r.id}"
                      onclick="openDeleteModal(this)">削除</button>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty records}">
          <tr><td colspan="9" class="empty">該当データがありません</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </section>

  <dialog id="delModal" aria-labelledby="delete-title">
    <form method="post"
          action="${pageContext.request.contextPath}/user/matches/delete"
          onsubmit="return validateAgree()">
      <h3 id="delete-title">対局レコード削除</h3>
      <p>この操作は取り消せません。選択中のレコードを削除します。よろしいですか？</p>
      <input type="hidden" name="id" id="delId">
      <input type="hidden" name="from" value="${from}">
      <input type="hidden" name="to" value="${to}">
      <input type="hidden" name="order" value="${order}">
      <label class="agree">
        <input type="checkbox" name="agree" id="agreeChk" value="true">
        内容に同意します
      </label>
      <div class="modal-actions">
        <button type="button" class="btn" onclick="closeDeleteModal()">キャンセル</button>
        <button type="submit" class="btn danger">OK（削除）</button>
      </div>
    </form>
  </dialog>

  <style>
    .alert{padding:10px 12px;border-radius:8px;margin:0 0 12px}
    .alert.success{background:#e8f5e9;color:#1b5e20}
    .alert.error{background:#fdecea;color:#b71c1c}
    .search-card,.list-card{background:#fff;border:1px solid #dfe3e8;border-radius:12px;padding:16px}
    .search-card h2,.list-heading h2{margin:0;font-size:1.05rem}
    .search-form{display:flex;align-items:end;gap:10px;margin-top:12px;flex-wrap:wrap}
    .date-field{display:flex;flex-direction:column;gap:5px;color:#4b5563;font-size:.88rem;font-weight:600}
    .date-field input{height:42px;padding:8px 10px;border:1px solid #cbd5e1;border-radius:8px;background:#fff;font-size:16px}
    .date-field input:focus{outline:3px solid rgba(37,99,235,.18);border-color:#2563eb}
    .tilde{align-self:center;margin-top:20px;color:#64748b}
    .btn{display:inline-flex;min-height:40px;align-items:center;justify-content:center;padding:7px 12px;border:1px solid #94a3b8;border-radius:7px;background:#fff;color:#1f2937;text-decoration:none;cursor:pointer;font-weight:600;white-space:nowrap}
    .btn.primary{background:#1976d2;color:#fff;border-color:#1976d2}
    .btn.edit{color:#1d4ed8;border-color:#93c5fd}
    .btn.danger{background:#dc2626;color:#fff;border-color:#dc2626}
    .search-btn{min-width:92px}
    .toggle{display:flex;align-items:center;gap:7px;min-height:42px;margin-left:auto;color:#475569;font-size:.9rem}
    .switch{position:relative;display:inline-block;width:48px;height:26px}
    .switch input{position:absolute;opacity:0}
    .slider{position:absolute;cursor:pointer;inset:0;background:#cbd5e1;transition:.2s;border-radius:26px}
    .slider:before{position:absolute;content:"";height:20px;width:20px;left:3px;bottom:3px;background:#fff;transition:.2s;border-radius:50%;box-shadow:0 1px 3px rgba(0,0,0,.25)}
    .switch input:checked + .slider{background:#2e7d32}
    .switch input:checked + .slider:before{transform:translateX(22px)}
    .switch input:focus-visible + .slider{outline:3px solid rgba(37,99,235,.25);outline-offset:2px}

    .list-card{margin-top:16px;padding:0;overflow:hidden}
    .list-heading{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 16px;border-bottom:1px solid #e5e7eb}
    .swipe-hint{display:none;color:#64748b;font-size:12px}
    .list-wrap{overflow-x:auto;overscroll-behavior-inline:contain;-webkit-overflow-scrolling:touch}
    .list{width:100%;min-width:960px;border-collapse:separate;border-spacing:0}
    .list th,.list td{padding:10px 9px;border-right:1px solid #e5e7eb;border-bottom:1px solid #e5e7eb;text-align:center;white-space:nowrap}
    .list thead th{position:sticky;top:0;z-index:2;background:#e8f5e9;color:#1f4322}
    .list tr:nth-child(even) td{background:#f8fafc}
    .list th:first-child,.list td:first-child{position:sticky;left:0;z-index:3;background:#fff}
    .list thead th:first-child{z-index:4;background:#dcefe0}
    .list tr:nth-child(even) td:first-child{background:#f1f5f9}
    .ops{display:flex;gap:8px;justify-content:center}
    .empty{text-align:center!important;color:#64748b}
    dialog{width:min(420px,calc(100vw - 24px));border:0;border-radius:12px;padding:20px;box-shadow:0 20px 48px rgba(15,23,42,.3)}
    dialog::backdrop{background:rgba(15,23,42,.55)}
    dialog h3{margin-top:0}
    .agree{display:flex;align-items:center;gap:8px;min-height:44px;margin-top:12px}
    .agree input{width:20px;height:20px}
    .modal-actions{display:flex;justify-content:flex-end;gap:8px;margin-top:16px}

    @media(max-width:768px){
      .search-card{padding:12px}
      .search-form{display:grid;grid-template-columns:1fr auto 1fr;gap:8px}
      .date-field input{width:100%;min-width:0;height:46px}
      .tilde{margin-top:22px}
      .search-btn{grid-column:1/-1;min-height:46px}
      .toggle{grid-column:1/-1;justify-content:center;margin-left:0}
      .list-card{margin-top:12px}
      .list-heading{padding:12px}
      .swipe-hint{display:inline}
      .list{min-width:900px}
      .list th,.list td{padding:8px}
      .btn{min-height:44px}
    }
  </style>

  <script>
    function openDeleteModal(btn){
      document.getElementById('delId').value = btn.getAttribute('data-id');
      document.getElementById('agreeChk').checked = false;
      document.getElementById('delModal').showModal();
    }
    function closeDeleteModal(){
      document.getElementById('delModal').close();
    }
    function validateAgree(){
      if(!document.getElementById('agreeChk').checked){
        showAppMessage('削除には同意チェックが必要です。', '入力内容を確認してください');
        return false;
      }
      return true;
    }
    (function(){
      const toggle = document.getElementById('orderToggle');
      const orderInput = document.getElementById('orderInput');
      if(toggle){
        toggle.addEventListener('change', function(){
          orderInput.value = this.checked ? 'desc' : 'asc';
          document.getElementById('searchForm').submit();
        });
      }
    })();
  </script>
</u:layout>
