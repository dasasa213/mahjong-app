<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="u"  tagdir="/WEB-INF/tags/user" %>

<u:layout title="総合成績" active="${active}">
  <style>
    .overall-card{background:#fff;border:1px solid #dfe3e8;border-radius:12px;overflow:hidden}
    .overall-heading{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 16px;border-bottom:1px solid #e5e7eb}
    .overall-heading h2{margin:0;font-size:1.05rem}
    .overall-periods{display:flex;flex-wrap:wrap;gap:8px;padding:12px 16px 0}
    .overall-period{display:inline-flex;align-items:center;justify-content:center;min-height:44px;padding:0 16px;border:1px solid #cbd5e1;border-radius:8px;color:#334155;text-decoration:none;font-weight:700;background:#fff}
    .overall-period:hover{background:#f1f5f9}
    .overall-period[aria-current="page"]{background:#2e7d32;border-color:#2e7d32;color:#fff}
    .overall-period:focus-visible{outline:3px solid #1565c0;outline-offset:3px}
    .period-description{margin:10px 16px 14px;color:#475569;font-size:13px;line-height:1.6}
    .period-description p{margin:4px 0}
    .swipe-hint{display:none;color:#64748b;font-size:12px;text-align:right}
    .overall-wrap{width:100%;overflow:auto;overscroll-behavior:contain;-webkit-overflow-scrolling:touch;max-height:calc(100vh - 150px)}
    .overall-table{width:100%;min-width:860px;border-collapse:separate;border-spacing:0}
    .overall-table th,.overall-table td{min-width:132px;padding:10px 12px;border-right:1px solid #e5e7eb;border-bottom:1px solid #e5e7eb;text-align:right;white-space:nowrap}
    .overall-table th:first-child,.overall-table td:first-child{width:170px;min-width:170px;text-align:left}
    .overall-table thead th{position:sticky;top:0;z-index:3;background:#2e7d32;color:#fff;font-weight:700}
    .overall-table thead th:first-child{left:0;z-index:5;background:#256b2a}
    .overall-table tbody tr:nth-child(even) td{background:#f8fafc}
    .overall-table .metric-name{position:sticky;left:0;z-index:2;background:#f1f5f9;font-weight:700;color:#334155}
    .overall-table tbody tr:nth-child(even) .metric-name{background:#e9eef3}
    .overall-table tbody tr:hover td{background:#fffde7}
    .overall-table tbody tr:hover .metric-name{background:#f5f0ce}
    .overall-table .counter-stat td{background:#f3f8f3}
    .overall-table .counter-stat .metric-name{background:#e1eee2;color:#245c28}
    .overall-table .counter-stat-start td{border-top:5px solid #81b985}
    .overall-table tbody tr.counter-stat:hover td{background:#fffde7}
    .overall-table tbody tr.counter-stat:hover .metric-name{background:#f5f0ce}
    .pos{color:#d32f2f;font-weight:700}
    .neg{color:#1565c0;font-weight:700}

    @media(max-width:768px){
      .overall-card{border-radius:10px}
      .overall-heading{padding:12px;align-items:flex-start;flex-direction:column;gap:4px}
      .swipe-hint{display:block;text-align:left}
      .overall-wrap{max-height:calc(100dvh - 140px)}
      .overall-table{min-width:max-content}
      .overall-table th,.overall-table td{min-width:124px;padding:10px 9px;font-size:14px}
      .overall-table th:first-child,.overall-table td:first-child{width:140px;min-width:140px}
    }
  </style>

  <section class="overall-card" aria-labelledby="overall-title">
    <div class="overall-heading">
      <h2 id="overall-title">グループ成績一覧</h2>
      <span class="swipe-hint">横にスワイプして他のユーザーを表示できます</span>
    </div>
    <c:url var="allUrl" value="/user/overall"><c:param name="period" value="all" /></c:url>
    <c:url var="recentUrl" value="/user/overall"><c:param name="period" value="recent100" /></c:url>
    <nav class="overall-periods" aria-label="総合成績の集計期間">
      <a class="overall-period" href="${allUrl}" aria-current="${period == 'all' ? 'page' : 'false'}">通算</a>
      <a class="overall-period" href="${recentUrl}" aria-current="${period == 'recent100' ? 'page' : 'false'}">直近100半荘</a>
      <c:forEach var="y" items="${years}">
        <c:url var="yearUrl" value="/user/overall"><c:param name="period" value="year" /><c:param name="year" value="${y}" /></c:url>
        <a class="overall-period" href="${yearUrl}" aria-current="${period == 'year' and selectedYear == y ? 'page' : 'false'}">${y}年</a>
      </c:forEach>
    </nav>
    <div id="period-description" class="period-description">
      <c:choose>
        <c:when test="${period == 'recent100'}">
          <p>各プレイヤーが参加した直近100半荘を集計します。100半荘未満の場合は全半荘が対象です。</p>
          <p>局数・和了率・副露率・立直率・放銃率は日単位の記録のため、直近100半荘では「—」と表示します。</p>
        </c:when>
        <c:when test="${period == 'year'}">
          <p>${selectedYear}年1月1日〜12月31日の成績です。</p>
        </c:when>
        <c:otherwise><p>これまでのすべての成績です。</p></c:otherwise>
      </c:choose>
      <p>参加日数は対象の半荘をプレイした日数です。対局のない期間の平均順位・順位率は「—」と表示します。</p>
    </div>
    <div class="overall-wrap" tabindex="0" aria-describedby="period-description">
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
              <c:choose>
                <c:when test="${byUser[name].hanshanCount > 0}"><fmt:formatNumber value="${byUser[name].avgRank}" maxFractionDigits="2" minFractionDigits="2" /></c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>

        <%-- 直近100戦平均は専用タブで確認するため非表示。
        <c:if test="${period == 'all'}">
        <!-- 直近100半荘の平均順位（小さいほど良いので色付けはしない） -->
        <tr>
          <td class="metric-name">直近100戦平均</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${byUser[name].hanshanCount > 0}"><fmt:formatNumber value="${byUser[name].recent100AvgRank}" maxFractionDigits="2" minFractionDigits="2" /></c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>

        </c:if>
        --%>

        <!-- 1位率〜4位率 -->
        <tr>
          <td class="metric-name">1位率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${byUser[name].hanshanCount > 0}"><fmt:formatNumber value="${byUser[name].rate1}" maxFractionDigits="2" minFractionDigits="2" />%</c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>
        <tr>
          <td class="metric-name">2位率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${byUser[name].hanshanCount > 0}"><fmt:formatNumber value="${byUser[name].rate2}" maxFractionDigits="2" minFractionDigits="2" />%</c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>
        <tr>
          <td class="metric-name">3位率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${byUser[name].hanshanCount > 0}"><fmt:formatNumber value="${byUser[name].rate3}" maxFractionDigits="2" minFractionDigits="2" />%</c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>
        <tr>
          <td class="metric-name">4位率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${byUser[name].hanshanCount > 0}"><fmt:formatNumber value="${byUser[name].rate4}" maxFractionDigits="2" minFractionDigits="2" />%</c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
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
        <tr class="counter-stat counter-stat-start">
          <td class="metric-name">局数</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${counterStatsAvailable}">
                  <fmt:formatNumber
                  value="${byUser[name].handCount}"
                  pattern="#,##0" />
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>

        <tr class="counter-stat">
          <td class="metric-name">和了率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${counterStatsAvailable and byUser[name].handCount > 0}">
                  <fmt:formatNumber
                  value="${byUser[name].winRate}"
                  maxFractionDigits="2"
                  minFractionDigits="2" />%
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>

        <tr class="counter-stat">
          <td class="metric-name">副露率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${counterStatsAvailable and byUser[name].handCount > 0}">
                  <fmt:formatNumber
                  value="${byUser[name].callRate}"
                  maxFractionDigits="2"
                  minFractionDigits="2" />%
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>

        <tr class="counter-stat">
          <td class="metric-name">立直率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${counterStatsAvailable and byUser[name].handCount > 0}">
                  <fmt:formatNumber
                  value="${byUser[name].riichiRate}"
                  maxFractionDigits="2"
                  minFractionDigits="2" />%
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>

        <tr class="counter-stat">
          <td class="metric-name">放銃率</td>
          <c:forEach var="name" items="${userNames}">
            <td>
              <c:choose>
                <c:when test="${counterStatsAvailable and byUser[name].handCount > 0}">
                  <fmt:formatNumber
                  value="${byUser[name].dealInRate}"
                  maxFractionDigits="2"
                  minFractionDigits="2" />%
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </c:forEach>
        </tr>
      </tbody>
    </table>
    </div>
  </section>
</u:layout>
