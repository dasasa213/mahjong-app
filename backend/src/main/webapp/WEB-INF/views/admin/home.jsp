<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
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
    /* レイアウト共通の余白がある前提。左に寄せて読みやすく */
    .group-info{
      margin:8px 0 16px;
      font-size:14px;
      color:#374151;
    }
    .group-info .label{ color:#6b7280; margin-right:4px; }
    .group-info .sep{ margin:0 6px; color:#9ca3af; }
    .group-info .created{ margin-left:10px; color:#6b7280; }

    .card{ background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:16px; }
    /* 表の横幅を「いい感じ」に制限して左寄せ */
    .card.narrow{ width:720px; max-width:100%; }

    .section-title{ margin:0 0 10px; font-size:16px; }

    .table{ width:100%; border-collapse:collapse; table-layout:fixed; }
    .table th,.table td{ border-top:1px solid #eee; padding:10px 12px; text-align:left; }
    .table thead th{ background:#f8fafc; border-top:none; font-weight:600; }

    /* 列幅を固定して揃える */
    .members .col-id{ width:110px; }
    .members .col-login{ width:auto; }   /* 残り全部 */
    .members .col-type{ width:120px; }

    .table tbody tr:hover{ background:#f9fafb; }
    .empty{ text-align:center; color:#6b7280; }
  </style>
</t:layout>
