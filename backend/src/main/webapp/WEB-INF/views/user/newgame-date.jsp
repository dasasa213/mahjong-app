<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="新規対局：日付選択" active="newgame">
  <div class="container">
    <h2>新規対局：日付を選択</h2>

    <form method="post" action="${pageContext.request.contextPath}/user/newgame/date" class="card">
      <div class="row">
        <label for="gamedate">対局日</label>
        <input type="date" id="gamedate" name="gamedate" value="${today}" required />
      </div>
      <p class="hint">※ この日付の「次の対局番号」を自動採番して作成します。</p>
      <div class="actions">
        <button type="submit" class="btn btn-primary">対局者選択へ進む</button>
      </div>
    </form>
  </div>

  <style>
    .container{max-width:560px;margin:16px auto;padding:0 12px}
    .card{background:#fff;border:1px solid #e5e7eb;border-radius:12px;padding:16px}
    .row{display:flex;gap:12px;align-items:center;margin:10px 0}
    .row label{width:90px;font-weight:600}
    .row input{flex:1;max-width:260px;padding:8px;border:1px solid #d1d5db;border-radius:8px}
    .hint{color:#6b7280;margin:6px 2px 14px}
    .actions{display:flex;gap:10px}
    .btn{padding:8px 14px;border-radius:10px;border:1px solid #d1d5db;background:#f9fafb;text-decoration:none}
    .btn-primary{background:#2563eb;border-color:#2563eb;color:#fff}
    @media (max-width:640px){.row{flex-direction:column;align-items:stretch}.row label{width:auto}}
  </style>
</u:layout>
