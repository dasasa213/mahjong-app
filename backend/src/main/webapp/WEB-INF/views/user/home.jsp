<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="u"  tagdir="/WEB-INF/tags/user" %>

<u:layout title="利用者ホーム" active="home">
  <style>
    .stats-wrap {
      display:grid; gap:12px;
      grid-template-columns: repeat(4, minmax(0,1fr));
    }
    @media (max-width: 980px){ .stats-wrap { grid-template-columns: repeat(2, minmax(0,1fr)); } }
    @media (max-width: 520px){ .stats-wrap { grid-template-columns: 1fr; } }

    .stat-card {
      border:1px solid #e5e7eb; border-radius:14px; padding:16px 14px;
      box-shadow: 0 1px 2px rgba(0,0,0,.04);
      background:#fff;
    }
    .stat-title { font-size:.92rem; color:#556; margin-bottom:8px; }
    .stat-value { font-size:1.8rem; font-weight:700; line-height:1.2; }
    .muted { color:#6b7280; font-size:.86rem; margin-top:6px; }
  </style>

  <div class="stats-wrap">
    <!-- 直近の対局日 -->
    <div class="stat-card">
      <div class="stat-title">直近の対局日</div>
      <div class="stat-value">
        <c:choose>
          <c:when test="${not empty s.lastDate}">
            <fmt:formatDate value="${s.lastDate}" pattern="yyyy/MM/dd" />
          </c:when>
          <c:otherwise>—</c:otherwise>
        </c:choose>
      </div>
      <div class="muted">グループ内の最終対局日</div>
    </div>

    <!-- 合計点数 -->
    <div class="stat-card">
      <div class="stat-title">合計点数</div>
      <div class="stat-value">
        <fmt:formatNumber value="${s.totalPoint}" />
      </div>
      <div class="muted">あなたの累計ポイント</div>
    </div>

    <!-- 合計金額 -->
    <div class="stat-card">
      <div class="stat-title">合計金額</div>
      <div class="stat-value">
        <fmt:formatNumber value="${s.totalAmount}" type="currency" currencySymbol="¥" />
      </div>
      <div class="muted">あなたの累計収支</div>
    </div>

    <!-- 平均順位 -->
    <div class="stat-card">
      <div class="stat-title">平均順位</div>
      <div class="stat-value">
        <c:choose>
          <c:when test="${s.avgRank gt 0}">
            <fmt:formatNumber value="${s.avgRank}" minFractionDigits="2" maxFractionDigits="2" />
          </c:when>
          <c:otherwise>—</c:otherwise>
        </c:choose>
      </div>
      <div class="muted">その日までの順位合計 ÷ 対局数</div>
    </div>
  </div>
</u:layout>
