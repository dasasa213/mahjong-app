<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="u"  tagdir="/WEB-INF/tags/user" %>

<u:layout title="利用者ホーム" active="home">
  <style>
    .stats-wrap{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px}
    .stat-card{min-width:0;padding:18px 16px;border:1px solid #dfe3e8;border-radius:12px;background:#fff;box-shadow:0 1px 2px rgba(15,23,42,.04)}
    .stat-card::before{content:"";display:block;width:36px;height:4px;margin-bottom:12px;border-radius:4px;background:#2e7d32}
    .stat-title{margin-bottom:7px;color:#475569;font-size:.9rem;font-weight:600}
    .stat-value{overflow:hidden;color:#172554;font-size:clamp(1.35rem,2.4vw,1.9rem);font-weight:750;line-height:1.25;text-overflow:ellipsis;white-space:nowrap}
    .muted{margin-top:7px;color:#64748b;font-size:.8rem;line-height:1.45}
    @media(max-width:1050px){.stats-wrap{grid-template-columns:repeat(2,minmax(0,1fr))}}
    @media(max-width:520px){
      .stats-wrap{grid-template-columns:repeat(2,minmax(0,1fr));gap:9px}
      .stat-card{padding:13px 11px;border-radius:10px}
      .stat-card::before{margin-bottom:9px}
      .stat-value{font-size:1.25rem}
      .muted{font-size:.74rem}
    }
    @media(max-width:350px){.stats-wrap{grid-template-columns:1fr}}
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
