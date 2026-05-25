<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u"  tagdir="/WEB-INF/tags/user" %>

<u:layout title="対人別成績" active="${active}">
  <style>
    .pairwise-note { margin: 0 0 14px; color: #455a64; line-height: 1.7; }
    .pairwise-wrap { overflow-x: auto; }
    .pairwise-table { border-collapse: collapse; min-width: 720px; width: 100%; }
    .pairwise-table th,
    .pairwise-table td { border: 1px solid #ddd; padding: 8px 10px; text-align: right; white-space: nowrap; }
    .pairwise-table th:first-child,
    .pairwise-table td:first-child { text-align: left; position: sticky; left: 0; z-index: 1; }
    .pairwise-table thead th { background: #2e7d32; color: #fff; }
    .pairwise-table tbody th { background: #f7f7f7; font-weight: 600; }
    .pairwise-table td.self { color: #777; text-align: center; background: #fafafa; }
    .pairwise-table td.nodata { color: #aaa; text-align: center; }
    .pairwise-table td.pos { color: #e53935; font-weight: 600; }
    .pairwise-table td.neg { color: #1e88e5; font-weight: 600; }
    @media (max-width: 640px){
      .pairwise-table th, .pairwise-table td { padding: 6px; }
    }
  </style>

  <p class="pairwise-note">
    行の人と列の人が同卓した半荘だけを集計し、行の人の平均順位 − 列の人の平均順位を表示します。<br>
    プラスは行の人の平均順位が高い＝順位が悪い、マイナスは行の人の平均順位が低い＝順位が良い、という意味です。
  </p>

  <div class="pairwise-wrap">
    <table class="pairwise-table">
      <thead>
        <tr>
          <th>名前</th>
          <c:forEach var="name" items="${userNames}">
            <th><c:out value="${name}" /></th>
          </c:forEach>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="rowName" items="${userNames}">
          <tr>
            <th><c:out value="${rowName}" /></th>
            <c:forEach var="colName" items="${userNames}">
              <c:set var="cell" value="${matrix[rowName][colName]}" />
              <td class="${cell.cssClass}">
                <c:choose>
                  <c:when test="${empty cell.displayValue}">-</c:when>
                  <c:otherwise><c:out value="${cell.displayValue}" /></c:otherwise>
                </c:choose>
              </td>
            </c:forEach>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</u:layout>
