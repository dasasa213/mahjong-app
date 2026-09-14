<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="新規対局：作成完了" active="newgame">
  <div class="wrap">
    <div class="complete-mark" aria-hidden="true">✓</div>
    <h2>対局を作成しました</h2>
    <div class="card">
      <p>対局日：${gamedate}</p>
      <p>対局番号：${gameno}</p>
      <p>game_id：${gameId}</p>
      <h3>参加者</h3>
      <c:choose>
        <c:when test="${empty players}">
          <div class="muted">参加者が登録されていません。</div>
        </c:when>
        <c:otherwise>
          <ul>
            <c:forEach var="n" items="${players}">
              <li>${n}</li>
            </c:forEach>
          </ul>
        </c:otherwise>
      </c:choose>
    </div>
    <div class="actions">
      <a class="btn" href="${pageContext.request.contextPath}/user/newgame/players">戻る</a>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/user/home">ホームへ</a>
    </div>
  </div>

  <style>
    .wrap{max-width:700px;margin:0 auto;text-align:center}
    .complete-mark{display:grid;width:52px;height:52px;place-items:center;margin:0 auto 10px;border-radius:50%;background:#2e7d32;color:#fff;font-size:28px;font-weight:700}
    .wrap h2{margin:0 0 16px;font-size:1.25rem}
    .card{padding:18px;background:#fff;border:1px solid #dfe3e8;border-radius:12px;text-align:left}
    .card p{margin:7px 0}
    .card h3{margin:16px 0 7px;font-size:1rem}
    ul{margin:8px 0 0;padding-left:24px}
    li{padding:3px 0}
    .btn{display:inline-flex;min-height:46px;align-items:center;justify-content:center;padding:9px 18px;border:1px solid #cbd5e1;border-radius:9px;background:#fff;color:#334155;text-decoration:none;font-weight:700}
    .btn-primary{background:#2e7d32;border-color:#2e7d32;color:#fff}
    .actions{display:flex;justify-content:center;gap:10px;margin-top:14px}
    .muted{color:#64748b}
    @media(max-width:640px){
      .card{padding:14px}
      .actions{display:grid;grid-template-columns:1fr 1fr}
      .actions .btn{width:100%}
    }
  </style>
</u:layout>
