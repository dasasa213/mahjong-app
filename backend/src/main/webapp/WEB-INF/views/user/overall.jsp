<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="u"  tagdir="/WEB-INF/tags/user" %>

<u:layout title="総合成績" active="${active}">
  <style>
    /* 必要最低限。既存のCSSがあればそちらが優先されます */
    .overall-wrap { overflow-x:auto; }
    .overall-table { border-collapse: collapse; min-width: 860px; width: 100%; }
    .overall-table th, .overall-table td { border: 1px solid #ddd; padding: 8px; text-align: right; white-space: nowrap; }
    .overall-table th:first-child, .overall-table td:first-child { text-align: left; }
    .overall-table thead th { background: #2e7d32; color: #fff; position: sticky; top: 0; }
    .metric-name { background: #f7f7f7; font-weight: 600; }
    .pos { color: #e53935; font-weight: 600; }  /* 赤 */
    .neg { color: #1e88e5; font-weight: 600; }  /* 青 */
    @media (max-width: 640px){
      .overall-table th, .overall-table td { padding: 6px; }
    }
  </style>

  <div class="overall-wrap">
    <table class="overall-table">
      <thead>
        <tr>
          <th>項目</th>
          <c:forEach var="name" items="${userNames}">
            <th><c:out value="${name}" /></th>
          </c:forEach>
        </tr>
      </thead>
      <tbody>
        <!-- 合計点数 -->
        <tr>
          <td class="metric-name">合計点数</td>
          <c:forEach var="name" items="${userNames}">
            <c:set var="v" value="${byUser[name].totalPoint}" />
            <td class="${v >= 0 ? 'pos' : 'neg'}">
              <fmt:formatNumber value="${v}" pattern="#,##0" />
            </td>
          </c:forEach>
        </tr>

        <!-- 合計金額 -->
        <tr>
          <td class="metric-name">合計金額</td>
          <c:forEach var="name" items="${userNames}">
            <c:set var="v" value="${byUser[name].totalAmount}" />
            <td class="${v >= 0 ? 'pos' : 'neg'}">
              <fmt:formatNumber value="${v}" pattern="#,##0" />
            </td>
          </c:forEach>
        </tr>

        <!-- 平均順位（小さいほど良いので色付けはしない） -->
        <tr>
          <td class="metric-name">平均順位</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].avgRank}" maxFractionDigits="2" minFractionDigits="2" />
            </td>
          </c:forEach>
        </tr>

        <!-- 1位率〜4位率 -->
        <tr>
          <td class="metric-name">1位率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].rate1}" maxFractionDigits="2" minFractionDigits="2" />%
            </td>
          </c:forEach>
        </tr>
        <tr>
          <td class="metric-name">2位率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].rate2}" maxFractionDigits="2" minFractionDigits="2" />%
            </td>
          </c:forEach>
        </tr>
        <tr>
          <td class="metric-name">3位率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].rate3}" maxFractionDigits="2" minFractionDigits="2" />%
            </td>
          </c:forEach>
        </tr>
        <tr>
          <td class="metric-name">4位率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].rate4}" maxFractionDigits="2" minFractionDigits="2" />%
            </td>
          </c:forEach>
        </tr>

        <!-- 参加日数 -->
        <tr>
          <td class="metric-name">参加日数</td>
          <c:forEach var="name" items="${userNames}">
            <td><fmt:formatNumber value="${byUser[name].participateDays}" pattern="#,##0" /></td>
          </c:forEach>
        </tr>

        <!-- 半荘数 -->
        <tr>
          <td class="metric-name">半荘数</td>
          <c:forEach var="name" items="${userNames}">
            <td><fmt:formatNumber value="${byUser[name].hanshanCount}" pattern="#,##0" /></td>
          </c:forEach>
        </tr>
      </tbody>
    </table>
  </div>
</u:layout>
