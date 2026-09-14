<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="u"  tagdir="/WEB-INF/tags/user" %>

<u:layout title="総合成績" active="${active}">
  <style>
    .overall-card{background:#fff;border:1px solid #dfe3e8;border-radius:12px;overflow:hidden}
    .overall-heading{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 16px;border-bottom:1px solid #e5e7eb}
    .overall-heading h2{margin:0;font-size:1.05rem}
    .swipe-hint{display:none;color:#64748b;font-size:12px;text-align:right}
    .overall-wrap{width:100%;overflow:auto;overscroll-behavior:contain;-webkit-overflow-scrolling:touch;max-height:calc(100vh - 150px)}
    .overall-table{width:100%;min-width:860px;border-collapse:separate;border-spacing:0}
    .overall-table th,.overall-table td{min-width:132px;padding:10px 12px;border-right:1px solid #e5e7eb;border-bottom:1px solid #e5e7eb;text-align:right;white-space:nowrap}
    .overall-table th:first-child,.overall-table td:first-child{width:190px;min-width:190px;text-align:left}
    .overall-table thead th{position:sticky;top:0;z-index:3;background:#2e7d32;color:#fff;font-weight:700}
    .overall-table thead th:first-child{left:0;z-index:5;background:#256b2a}
    .overall-table tbody tr:nth-child(even) td{background:#f8fafc}
    .overall-table .metric-name{position:sticky;left:0;z-index:2;background:#f1f5f9;font-weight:700;color:#334155}
    .overall-table tbody tr:nth-child(even) .metric-name{background:#e9eef3}
    .overall-table tbody tr:hover td{background:#fffde7}
    .overall-table tbody tr:hover .metric-name{background:#f5f0ce}
    .pos{color:#d32f2f;font-weight:700}
    .neg{color:#1565c0;font-weight:700}

    @media(max-width:768px){
      .overall-card{border-radius:10px}
      .overall-heading{padding:12px;align-items:flex-start;flex-direction:column;gap:4px}
      .swipe-hint{display:block;text-align:left}
      .overall-wrap{max-height:calc(100dvh - 140px)}
      .overall-table{min-width:max-content}
      .overall-table th,.overall-table td{min-width:124px;padding:10px 9px;font-size:14px}
      .overall-table th:first-child,.overall-table td:first-child{width:158px;min-width:158px}
    }
  </style>

  <section class="overall-card" aria-labelledby="overall-title">
    <div class="overall-heading">
      <h2 id="overall-title">グループ成績一覧</h2>
      <span class="swipe-hint">横にスワイプして他のユーザーを表示できます</span>
    </div>
    <div class="overall-wrap" tabindex="0">
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

        <!-- 直近100半荘の平均順位（小さいほど良いので色付けはしない） -->
        <tr>
          <td class="metric-name">直近100半荘平均順位</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].recent100AvgRank}" maxFractionDigits="2" minFractionDigits="2" />
            </td>
          </c:forEach>
        </tr>

        <tr>
          <td class="metric-name">1日の期待値</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].hopeP}" maxFractionDigits="2" minFractionDigits="2" />
            </td>
          </c:forEach>
        </tr>
        <tr>
          <td class="metric-name">標準偏差</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].hensa}" maxFractionDigits="2" minFractionDigits="2" />
            </td>
          </c:forEach>
        </tr>

        <tr>
          <td class="metric-name">前半点数</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].beforePoint}" />
            </td>
          </c:forEach>
        </tr>
        <tr>
          <td class="metric-name">後半点数</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber value="${byUser[name].afterPoint}" />
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
        <tr>
          <td class="metric-name">局数</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber
                  value="${byUser[name].handCount}"
                  pattern="#,##0" />
            </td>
          </c:forEach>
        </tr>

        <tr>
          <td class="metric-name">和了率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber
                  value="${byUser[name].winRate}"
                  maxFractionDigits="2"
                  minFractionDigits="2" />%
            </td>
          </c:forEach>
        </tr>

        <tr>
          <td class="metric-name">副露率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber
                  value="${byUser[name].callRate}"
                  maxFractionDigits="2"
                  minFractionDigits="2" />%
            </td>
          </c:forEach>
        </tr>

        <tr>
          <td class="metric-name">立直率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber
                  value="${byUser[name].riichiRate}"
                  maxFractionDigits="2"
                  minFractionDigits="2" />%
            </td>
          </c:forEach>
        </tr>

        <tr>
          <td class="metric-name">放銃率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <fmt:formatNumber
                  value="${byUser[name].dealInRate}"
                  maxFractionDigits="2"
                  minFractionDigits="2" />%
            </td>
          </c:forEach>
        </tr>
      </tbody>
    </table>
    </div>
  </section>
</u:layout>
