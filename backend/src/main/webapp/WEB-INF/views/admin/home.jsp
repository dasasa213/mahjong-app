<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/admin" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout title="管理者ホーム" active="${active}">

  <!-- グループ情報：左寄せでコンパクト -->
  <section class="group-info">
    <span class="label">グループID：</span><strong>${vm.groupId}</strong>
    <span class="sep">：</span><strong>${vm.groupName}</strong>
    <span class="created">（作成日：${vm.sakuseiDay}）</span>
  </section>

  <!-- メンバー一覧：左寄せ＆幅を固定して表を揃える -->
  <section class="card narrow">
    <h3 class="section-title">メンバー一覧（同グループ）</h3>
    <table class="table members">
      <thead>
        <tr>
          <th class="col-id">ユーザID</th>
          <th class="col-login">ログイン名</th>
          <th class="col-type">種別</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="m" items="${vm.members}">
          <tr>
            <td>${m.userId}</td>
            <td>${m.login}</td>
            <td>
              <c:choose>
                <c:when test="${m.userType == '1'}">管理者</c:when>
                <c:otherwise>利用者</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty vm.members}">
          <tr><td colspan="3" class="empty">メンバーがいません</td></tr>
        </c:if>
      </tbody>
    </table>
  </section>

  <style>
    .group-info{display:flex;align-items:center;gap:6px;flex-wrap:wrap;margin:0 0 14px;padding:12px 14px;border:1px solid #c8e6c9;border-radius:10px;background:#f1f8f2;color:#334155;font-size:14px}
    .group-info .label{color:#64748b}
    .group-info .sep{margin:0 2px;color:#94a3b8}
    .group-info .created{margin-left:auto;color:#64748b}
    .card{padding:16px;border:1px solid #dfe3e8;border-radius:12px;background:#fff}
    .card.narrow{width:760px;max-width:100%}
    .section-title{margin:0 0 12px;font-size:1.05rem}
    .table{width:100%;border-collapse:separate;border-spacing:0;table-layout:fixed}
    .table th,.table td{padding:11px 12px;border-bottom:1px solid #e5e7eb;text-align:left}
    .table thead th{background:#e8f5e9;color:#1f4322;font-weight:700}
    .members .col-id{width:120px}
    .members .col-login{width:auto}
    .members .col-type{width:120px}
    .table tbody tr:nth-child(even) td{background:#f8fafc}
    .table tbody tr:hover td{background:#fffde7}
    .empty{text-align:center;color:#64748b}
    @media(max-width:640px){
      .group-info{align-items:flex-start;flex-direction:column}
      .group-info .sep{display:none}
      .group-info .created{margin-left:0}
      .card{padding:10px 8px;overflow-x:auto}
      .table{min-width:520px}
      .table th,.table td{padding:10px 8px}
    }
  </style>
</t:layout>
