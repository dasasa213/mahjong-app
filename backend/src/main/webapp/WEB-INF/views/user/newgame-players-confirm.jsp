<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="新規対局：作成結果（仮）" active="newgame">
  <div class="wrap">
    <h2>作成しました</h2>
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
    .wrap{max-width:700px;margin:16px auto;padding:0 12px}
    .card{background:#fff;border:1px solid #e5e7eb;border-radius:12px;padding:12px}
    ul{margin:8px 0 0 18px}
    .btn{padding:8px 12px;border:1px solid #d1d5db;border-radius:10px;background:#f9fafb;text-decoration:none}
    .btn-primary{background:#2563eb;border-color:#2563eb;color:#fff}
    .actions{display:flex;gap:8px;margin-top:12px}
    .muted{color:#6b7280}
  </style>
</u:layout>
