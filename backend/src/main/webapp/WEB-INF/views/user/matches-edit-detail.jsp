<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<%-- 期待するモデル:
     - game : { id, gamedate(LocalDate), gameno, rate, points, returnpoints, uma1, uma2 }
     - players : List<String>（後続の表で使用予定）
 --%>

<u:layout title="対局編集" active="${active}">

  <c:if test="${not empty success}">
    <div class="alert success">${success}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert error">${error}</div>
  </c:if>

  <!-- 上部フォーム（計算/登録は仮） -->
  <form id="editForm" class="head-form" autocomplete="off">
    <input type="hidden" name="id" value="${game.id}"/>

    <!-- 日付 -->
    <div class="field full">
      <label>対局日</label>
      <input type="date" name="gamedate"
             value="<c:out value='${empty game.gamedate ? "" : game.gamedate}'/>" />
    </div>

    <!-- 回数 -->
    <div class="field full">
      <label>回</label>
      <input type="number" name="gameno" min="1" step="1"
             value="<c:out value='${empty game.gameno ? 1 : game.gameno}'/>" />
    </div>

    <!-- レート -->
    <div class="row">
      <div class="field">
        <label>レート</label>
        <div class="input-with-suffix">
          <input type="number" name="rate" min="0" step="1"
                 value="<c:out value='${empty game.rate ? 50 : game.rate}'/>" />
          <span class="suffix">ペソ</span>
        </div>
      </div>
    </div>

    <!-- 配点 / 返し点 -->
    <div class="row">
      <div class="field">
        <label>配点 / 返し点</label>
        <div class="pair">
          <input type="number" name="points" min="0" step="100"
                 value="<c:out value='${empty game.points ? 25000 : game.points}'/>" />
          <span class="pair-sep">／</span>
          <input type="number" name="returnpoints" min="0" step="100"
                 value="<c:out value='${empty game.returnpoints ? 30000 : game.returnpoints}'/>" />
        </div>
      </div>
    </div>

    <!-- ウマ1, ウマ2 -->
    <div class="row">
      <div class="field">
        <label>ウマ</label>
        <div class="pair">
          <input type="number" name="uma1" min="0" step="1"
                 value="<c:out value='${empty game.uma1 ? 30 : game.uma1}'/>" />
          <span class="pair-sep">／</span>
          <input type="number" name="uma2" min="0" step="1"
                 value="<c:out value='${empty game.uma2 ? 10 : game.uma2}'/>" />
        </div>
      </div>
    </div>

    <div class="actions">
      <button id="calcBtn" type="button" class="btn primary">計算</button>
      <button id="saveBtn" type="button" class="btn success">登録</button>
    </div>
  </form>

  <u:matchTables
      players="${players}"
      initialRows="4"
      calcBtnId="calcBtn"
      saveBtnId="saveBtn"
      idPrefix="mt" />

  <!-- ▼ この下に後続で「タブ + 点棒/順位/点数テーブル」を追加していく予定 -->
  <div id="tablesArea" class="mt"></div>

  <style>
    .alert{padding:8px 10px;border-radius:6px;margin:8px 0}
    .alert.success{background:#e8f5e9;color:#2e7d32}
    .alert.error{background:#fdecea;color:#b71c1c}

    .head-form{max-width:860px;margin:10px auto 0;display:flex;flex-direction:column;gap:14px}
    .row{display:flex;gap:14px;flex-wrap:wrap}
    .field{flex:1;min-width:240px}
    .field.full{width:100%}
    .field label{display:block;font-size:.95rem;color:#555;margin:0 0 6px 2px}
    .head-form input[type="date"],
    .head-form input[type="number"]{
      width:100%;padding:12px 14px;border:1px solid #cfd8dc;border-radius:10px;
      font-size:1.1rem;box-sizing:border-box;background:#fff
    }
    .input-with-suffix{position:relative}
    .input-with-suffix .suffix{
      position:absolute;right:10px;top:50%;transform:translateY(-50%);color:#777;font-size:.95rem
    }
    .pair{display:flex;align-items:center;gap:10px}
    .pair input{max-width:220px}
    .pair-sep{color:#666}

    .actions{display:flex;flex-direction:column;gap:12px;margin-top:6px}
    .btn{width:100%;padding:12px;border-radius:10px;border:1px solid transparent;
         font-size:1.05rem;cursor:pointer}
    .btn.primary{background:#1976d2;color:#fff}
    .btn.success{background:#2e7d32;color:#fff}
    .btn:disabled{opacity:.6;cursor:not-allowed}

    .mt{margin-top:24px}
  </style>

</u:layout>
