<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8" />
<title>ログイン</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  *{box-sizing:border-box}
  html,body{min-height:100%;margin:0}
  body{min-height:100vh;background:linear-gradient(145deg,#edf5ee 0%,#f4f6f8 48%,#eef2f7 100%);color:#1f2937;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI","Noto Sans JP","Hiragino Kaku Gothic ProN",Meiryo,sans-serif}
  .wrap{min-height:100vh;display:grid;place-items:center;padding:24px}
  .frame{width:min(920px,100%);padding:48px;border:1px solid #dfe3e8;border-radius:16px;background:rgba(255,255,255,.62)}
  .card{width:min(500px,100%);margin:0 auto;padding:36px 42px;border:1px solid #dfe3e8;border-top:5px solid #2e7d32;border-radius:12px;background:#fff;box-shadow:0 16px 38px rgba(15,23,42,.1)}
  h1{margin:0 0 26px;color:#1f2937;font-size:26px;letter-spacing:.08em;text-align:center}
  .row{display:grid;grid-template-columns:120px 1fr;align-items:center;gap:14px;margin:16px 0}
  .label{color:#374151;font-weight:600;text-align:right}
  .input{min-width:0}
  input[type=text],input[type=password]{width:100%;height:46px;padding:0 12px;border:1px solid #cbd5e1;border-radius:8px;background:#fff;font-size:16px}
  input:focus{outline:3px solid rgba(37,99,235,.18);border-color:#2563eb}
  .actions{margin-top:26px;text-align:center}
  .btn{width:min(240px,100%);min-height:48px;padding:11px 24px;border:0;border-radius:9px;background:#2e7d32;color:#fff;font-size:16px;font-weight:700;cursor:pointer}
  .btn:hover{filter:brightness(.95)}
  .btn:focus-visible{outline:3px solid rgba(37,99,235,.25);outline-offset:2px}
  .error{margin-top:16px;padding:10px 12px;border:1px solid #ef9a9a;border-radius:8px;background:#ffebee;color:#b71c1c;text-align:center}
  .note{margin-top:8px;color:#64748b;font-size:12px;text-align:center}
  @media(max-width:640px){
    .wrap{padding:14px}
    .frame{padding:0;border:0;background:transparent}
    .card{padding:28px 18px}
    h1{font-size:24px}
    .row{grid-template-columns:1fr;gap:7px;margin:18px 0}
    .label{text-align:left}
    .btn{width:100%}
  }
</style>
</head>
<body>
<div class="wrap">
  <div class="frame">
    <div class="card">
      <h1>ログイン</h1>
      <form method="post" action="${pageContext.request.contextPath}/main/login">
        <div class="row">
          <div class="label">ユーザ</div>
          <div class="input"><input type="text" name="loginName" required autofocus placeholder="例）岡部" value="${param.loginName}"></div>
        </div>
        <div class="row">
          <div class="label">パスワード</div>
          <div class="input"><input type="password" name="password" required placeholder="例）0000"></div>
        </div>
        <div class="actions"><button class="btn" type="submit">ログイン</button></div>
        <c:if test="${not empty error}"><div class="error">${error}</div></c:if>
      </form>
    </div>
  </div>
</div>
</body>
</html>
