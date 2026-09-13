<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8" />
<title>ログイン</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  html,
  body {
    min-height: 100%;
    margin: 0;
    font-family:
        system-ui,
        -apple-system,
        "Segoe UI",
        Roboto,
        "Hiragino Kaku Gothic ProN",
        "Yu Gothic",
        "メイリオ",
        sans-serif;

    background: #f3f4f6;
    color: #1f2937;
  }

  body {
    min-height: 100vh;
  }

  .wrap {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
    box-sizing: border-box;
  }

  .frame {
    width: 900px;
    max-width: 95vw;
    background: #e5e7eb;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    padding: 48px;
    box-sizing: border-box;
  }

  .card {
    width: 520px;
    max-width: 100%;
    margin: 0 auto;
    background: #dbeafe;
    border-radius: 8px;
    padding: 40px 48px;
    box-sizing: border-box;
    box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
  }

  h1 {
    margin: 0 0 24px;
    font-size: 24px;
    letter-spacing: .1em;
    text-align: center;
  }

  .row {
    display: flex;
    align-items: center;
    gap: 16px;
    margin: 16px 0;
  }

  .label {
    width: 120px;
    flex-shrink: 0;
    text-align: right;
    color: #374151;
  }

  .input {
    flex: 1;
    min-width: 0;
  }

  input[type=text],
  input[type=password] {
    width: 100%;
    height: 40px;
    border: 1px solid #cbd5e1;
    border-radius: 6px;
    padding: 0 10px;
    background: #fff;
    box-sizing: border-box;
    font-size: 16px;
  }

  .actions {
    margin-top: 28px;
    text-align: center;
  }

  .btn {
    display: inline-block;
    min-width: 160px;
    background: #f59e0b;
    border: none;
    color: #111827;
    font-weight: 600;
    padding: 11px 36px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 16px;
  }

  .error {
    margin-top: 16px;
    text-align: center;
    color: #b91c1c;
    background: #fee2e2;
    border: 1px solid #fecaca;
    border-radius: 6px;
    padding: 8px;
  }

  .note {
    margin-top: 8px;
    text-align: center;
    color: #6b7280;
    font-size: 12px;
  }


  /* スマホ */
  @media (max-width: 640px) {

    .wrap {
      min-height: 100vh;
      padding: 16px;
    }

    .frame {
      width: 100%;
      max-width: none;
      padding: 16px;
      border-radius: 8px;
    }

    .card {
      width: 100%;
      max-width: none;
      padding: 28px 20px;
    }

    h1 {
      margin-bottom: 28px;
      font-size: 26px;
    }

    .row {
      display: block;
      margin: 20px 0;
    }

    .label {
      width: auto;
      margin-bottom: 8px;
      text-align: left;
      font-size: 15px;
      font-weight: 600;
    }

    .input {
      width: 100%;
    }

    input[type=text],
    input[type=password] {
      width: 100%;
      height: 46px;
      font-size: 16px;
    }

    .actions {
      margin-top: 28px;
    }

    .btn {
      width: 100%;
      min-height: 46px;
      font-size: 16px;
    }
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
