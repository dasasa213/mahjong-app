<%@ tag description="対局編集: タブ付きテーブル(点棒/順位/点数)" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="players"     required="true"  type="java.util.List" %>
<%@ attribute name="initialRows" required="false" type="java.lang.Integer" %>
<%@ attribute name="calcBtnId"   required="false" type="java.lang.String"  %>
<%@ attribute name="saveBtnId"   required="false" type="java.lang.String"  %>
<%@ attribute name="idPrefix"    required="false" type="java.lang.String"  %>

<c:set var="pid"  value="${empty idPrefix ? 'mt' : idPrefix}" />
<c:set var="rows" value="${empty initialRows ? 4 : initialRows}" />

<c:set var="playersJson">
  [<c:forEach var="p" items="${players}" varStatus="s">"${fn:escapeXml(p)}"<c:if test="${!s.last}">,</c:if></c:forEach>]
</c:set>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/match-tables.css" />
<script src="${pageContext.request.contextPath}/js/match-tables.js"></script>

<!-- ★ container の id を JS と一致させる -->
<div id="${pid}-container"
     class="mt-module"
     data-players='${playersJson}'>
  <div class="tabs">
    <button class="tab active" data-tab="score">点棒</button>
    <button class="tab"          data-tab="rank">順位</button>
    <button class="tab"          data-tab="points">点数</button>
    <div class="tab-tools">
      <button type="button" class="btn outline" id="${pid}-addrow">行を追加</button>
    </div>
  </div>
  <div class="tabpanes">
    <div id="${pid}-pane-score"  class="pane active"></div>
    <div id="${pid}-pane-rank"   class="pane"></div>
    <div id="${pid}-pane-points" class="pane"></div>
  </div>
</div>

<!-- 初期化 -->
<script>
  window.addEventListener('DOMContentLoaded', function () {
    if (!window.matchTables) {
      console.error('match-tables.js が読み込まれていません');
      return;
    }
    window.matchTables.init({
      mount: {
        containerId: '${pid}-container',
        addRowBtnId: '${pid}-addrow',
        panes: {
          score:  '${pid}-pane-score',
          rank:   '${pid}-pane-rank',
          points: '${pid}-pane-points'
        },
        initialRows: ${rows}
      },
      buttons: {
        calcBtnId: '${empty calcBtnId ? "" : calcBtnId}',
        saveBtnId: '${empty saveBtnId ? "" : saveBtnId}'
      },
      players: ${playersJson}
    });
  });
</script>
