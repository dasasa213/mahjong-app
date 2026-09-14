<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="新規対局：日付選択" active="newgame">
  <div class="container">
    <div class="step-label">STEP 1 / 2</div>
    <h2>対局日を選択</h2>

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
    .container{max-width:620px;margin:0 auto}
    .step-label{margin-bottom:5px;color:#2e7d32;font-size:.8rem;font-weight:700;letter-spacing:.06em}
    .container h2{margin:0 0 14px;font-size:1.2rem}
    .card{padding:20px;background:#fff;border:1px solid #dfe3e8;border-radius:12px}
    .row{display:grid;grid-template-columns:100px 1fr;gap:12px;align-items:center}
    .row label{font-weight:700;color:#334155}
    .row input{width:100%;height:46px;padding:9px 12px;border:1px solid #cbd5e1;border-radius:8px;background:#fff;font-size:16px}
    .row input:focus{outline:3px solid rgba(37,99,235,.18);border-color:#2563eb}
    .hint{margin:12px 0 16px;color:#64748b;font-size:.88rem}
    .actions{display:flex;justify-content:flex-end}
    .btn{display:inline-flex;min-height:46px;align-items:center;justify-content:center;padding:9px 18px;border:1px solid #d1d5db;border-radius:9px;background:#f9fafb;text-decoration:none;font-weight:700;cursor:pointer}
    .btn-primary{background:#2e7d32;border-color:#2e7d32;color:#fff}
    @media(max-width:640px){
      .container h2{font-size:1.1rem}
      .card{padding:14px 12px}
      .row{grid-template-columns:1fr;gap:6px}
      .actions .btn{width:100%}
    }
  </style>
</u:layout>
