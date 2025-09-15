<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="対局編集" active="${active}">
  <h2>対局編集</h2>

  <!-- フラッシュメッセージ -->
  <c:if test="${not empty success}">
    <div class="alert success">${success}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert error">${error}</div>
  </c:if>

  <!-- 検索フォーム -->
  <form id="searchForm" method="get" action="${pageContext.request.contextPath}/user/matches/edit" class="search-form">
    <label>From：
      <input type="date" name="from" value="${from}" required />
    </label>
    <span class="tilde">～</span>
    <label>To：
      <input type="date" name="to" value="${to}" required />
    </label>
    <!-- 並び順 hidden -->
    <input type="hidden" name="order" id="orderInput" value="${order}" />
    <button type="submit" class="btn primary">検索</button>

    <!-- 並び順トグル -->
    <div class="toggle">
      <span>古い順</span>
      <label class="switch">
        <input type="checkbox" id="orderToggle" <c:if test="${order == 'desc'}">checked</c:if> />
        <span class="slider"></span>
      </label>
      <span>新しい順</span>
    </div>
  </form>

  <!-- 一覧 -->
  <div class="list-wrap">
    <table class="list">
      <thead>
      <tr>
        <th style="width:90px">ID</th>
        <th style="width:120px">対局日</th>
        <th style="width:80px">回</th>
        <th style="width:80px">レート</th>
        <th style="width:110px">持ち点</th>
        <th style="width:130px">返し点</th>
        <th style="width:80px">ウマ1</th>
        <th style="width:80px">ウマ2</th>
        <th style="width:160px">操作</th>
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
            <a class="btn" href="${pageContext.request.contextPath}/user/matches/edit/${r.id}">編集</a>
            <!-- 削除ボタン：モーダル起動 -->
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

  <!-- 削除モーダル -->
  <dialog id="delModal">
    <form method="post" action="${pageContext.request.contextPath}/user/matches/delete" onsubmit="return validateAgree()">
      <h3>対局レコード削除</h3>
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
    .search-form { display:flex; align-items:center; gap:.5rem; margin: 12px 0 16px; flex-wrap: wrap; }
    .tilde { margin:0 .25rem; }
    .list-wrap { overflow-x:auto; }
    .list { width:100%; border-collapse:collapse; }
    .list th, .list td { border:1px solid #ddd; padding:6px 8px; text-align:center; }
    .list thead th { background:#f2f6ff; }
    .ops { display:flex; gap:6px; justify-content:center; }
    .btn { padding:6px 10px; border:1px solid #888; background:#fff; cursor:pointer; border-radius:6px; }
    .btn.primary { background:#1967d2; color:#fff; border-color:#1967d2; }
    .btn.danger { background:#d21919; color:#fff; border-color:#d21919; }
    .alert { padding:8px 10px; border-radius:6px; margin:8px 0; }
    .alert.success { background:#e8f5e9; color:#2e7d32; }
    .alert.error { background:#fdecea; color:#b71c1c; }
    .empty { text-align:center; color:#666; }
    dialog { border:none; border-radius:10px; padding:16px; max-width:420px; }
    .agree { display:flex; align-items:center; gap:.5rem; margin-top:10px; }
    .modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:14px; }
    /* 並び替えトグル */
    .toggle { display:flex; align-items:center; gap:.5rem; margin-left: 12px; }
    .switch { position: relative; display: inline-block; width: 48px; height: 24px; }
    .switch input { display:none; }
    .slider { position:absolute; cursor:pointer; top:0; left:0; right:0; bottom:0;
              background:#ccc; transition:.2s; border-radius:24px; }
    .slider:before { position:absolute; content:""; height:18px; width:18px; left:3px; bottom:3px;
                     background:white; transition:.2s; border-radius:50%; }
    .switch input:checked + .slider { background:#1967d2; }
    .switch input:checked + .slider:before { transform: translateX(24px); }
  </style>

  <script>
    function openDeleteModal(btn){
      const id = btn.getAttribute('data-id');
      document.getElementById('delId').value = id;
      document.getElementById('agreeChk').checked = false;
      document.getElementById('delModal').showModal();
    }
    function closeDeleteModal(){
      document.getElementById('delModal').close();
    }
    function validateAgree(){
      if(!document.getElementById('agreeChk').checked){
        alert('削除には同意チェックが必要です。');
        return false;
      }
      return true;
    }

    // 並び順トグル
    (function(){
      const toggle = document.getElementById('orderToggle');
      const orderInput = document.getElementById('orderInput');
      if (toggle){
        toggle.addEventListener('change', function(){
          orderInput.value = this.checked ? 'desc' : 'asc';
          document.getElementById('searchForm').submit();
        });
      }
    })();
  </script>
</u:layout>
