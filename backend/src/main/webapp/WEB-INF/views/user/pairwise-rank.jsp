<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="対人別成績" active="${active}">
  <section class="pairwise-card" aria-labelledby="pairwise-title">
    <div class="pairwise-heading">
      <h2 id="pairwise-title">平均順位差</h2>
      <span class="swipe-hint">横にスワイプして他のユーザーを表示できます</span>
    </div>

    <nav class="year-tabs" aria-label="対人別成績の集計期間">
      <c:url var="allUrl" value="/user/pairwise-rank" />
      <a href="${allUrl}" aria-current="${empty selectedYear ? 'page' : 'false'}">通算</a>
      <c:forEach var="y" items="${years}">
        <c:url var="yearUrl" value="/user/pairwise-rank"><c:param name="year" value="${y}" /></c:url>
        <a href="${yearUrl}" aria-current="${selectedYear == y ? 'page' : 'false'}">${y}年</a>
      </c:forEach>
    </nav>
    <div class="pairwise-note">
      <c:if test="${not empty selectedYear}"><p>${selectedYear}年1月1日〜12月31日の対局が対象です。</p></c:if>
      <p>行と列のユーザーが同卓した半荘を対象に、行のユーザーの平均順位から列のユーザーの平均順位を引いた値です。</p>
      <div class="legend" aria-label="数値の見方">
        <span><i class="legend-good"></i>マイナス：行のユーザーが好成績</span>
        <span><i class="legend-bad"></i>プラス：行のユーザーが不調</span>
      </div>
    </div>

    <div class="pairwise-wrap" tabindex="0">
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
  </section>

  <style>
    .year-tabs{display:flex;flex-wrap:wrap;gap:8px;padding:12px 16px}
    .year-tabs a{display:inline-flex;align-items:center;min-height:44px;padding:0 16px;border:1px solid #cbd5e1;border-radius:8px;color:#334155;text-decoration:none;font-weight:700}
    .year-tabs a[aria-current="page"]{background:#2e7d32;border-color:#2e7d32;color:#fff}
    .year-tabs a:focus-visible{outline:3px solid #1565c0;outline-offset:3px}
    .pairwise-card{background:#fff;border:1px solid #dfe3e8;border-radius:12px;overflow:hidden}
    .pairwise-heading{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 16px;border-bottom:1px solid #e5e7eb}
    .pairwise-heading h2{margin:0;font-size:1.05rem}
    .swipe-hint{display:none;color:#64748b;font-size:12px}
    .pairwise-note{padding:12px 16px;background:#f8fafc;border-bottom:1px solid #e5e7eb;color:#475569;font-size:.9rem}
    .pairwise-note p{margin:0 0 8px}
    .legend{display:flex;gap:18px;flex-wrap:wrap}
    .legend span{display:inline-flex;align-items:center;gap:6px}
    .legend i{width:10px;height:10px;border-radius:50%}
    .legend-good{background:#1565c0}
    .legend-bad{background:#d32f2f}
    .pairwise-wrap{overflow:auto;overscroll-behavior:contain;-webkit-overflow-scrolling:touch;max-height:calc(100vh - 240px)}
    .pairwise-table{width:100%;min-width:720px;border-collapse:separate;border-spacing:0}
    .pairwise-table th,.pairwise-table td{min-width:125px;padding:11px 12px;border-right:1px solid #e5e7eb;border-bottom:1px solid #e5e7eb;text-align:right;white-space:nowrap}
    .pairwise-table thead th{position:sticky;top:0;z-index:3;background:#2e7d32;color:#fff;text-align:center}
    .pairwise-table thead th:first-child{left:0;z-index:5;background:#256b2a}
    .pairwise-table tbody th{position:sticky;left:0;z-index:2;background:#f1f5f9;text-align:left;font-weight:700}
    .pairwise-table tbody tr:nth-child(even) td{background:#f8fafc}
    .pairwise-table tbody tr:nth-child(even) th{background:#e9eef3}
    .pairwise-table td.self{background:#f1f5f9!important;color:#64748b;text-align:center}
    .pairwise-table td.nodata{color:#94a3b8;text-align:center}
    .pairwise-table td.pos{color:#d32f2f;font-weight:700}
    .pairwise-table td.neg{color:#1565c0;font-weight:700}
    @media(max-width:768px){
      .year-tabs{display:flex;flex-wrap:wrap;gap:8px;padding:12px 16px}
    .year-tabs a{display:inline-flex;align-items:center;min-height:44px;padding:0 16px;border:1px solid #cbd5e1;border-radius:8px;color:#334155;text-decoration:none;font-weight:700}
    .year-tabs a[aria-current="page"]{background:#2e7d32;border-color:#2e7d32;color:#fff}
    .year-tabs a:focus-visible{outline:3px solid #1565c0;outline-offset:3px}
    .pairwise-card{border-radius:10px}
      .pairwise-heading{padding:12px;align-items:flex-start;flex-direction:column;gap:4px}
      .swipe-hint{display:block;text-align:left}
      .pairwise-note{padding:10px 12px}
      .legend{display:grid;gap:5px}
      .pairwise-wrap{max-height:calc(100dvh - 250px)}
      .pairwise-table{min-width:max-content}
      .pairwise-table th,.pairwise-table td{min-width:118px;padding:10px 8px;font-size:14px}
      .pairwise-table th:first-child{min-width:120px}
    }
  </style>
</u:layout>
