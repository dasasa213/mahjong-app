<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="対局編集" active="${active}">

  <c:if test="${not empty success}">
    <div class="alert success" role="status">${success}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert error" role="alert">${error}</div>
  </c:if>

  <form id="editForm" class="match-form" autocomplete="off"
        action="${pageContext.request.contextPath}/user/matches/save" method="post">
    <input type="hidden" name="id"
           value="${empty saveTablesRequest.gameId ? game.id : saveTablesRequest.gameId}"/>
    <input type="hidden" id="savePayload" name="payload"/>

    <section class="settings-card" aria-labelledby="settings-title">
      <h2 id="settings-title" class="section-title">対局設定</h2>

      <div class="settings-grid">
        <div class="field">
          <label for="gamedate">対局日</label>
          <input id="gamedate" type="date" name="gamedate"
                 value="<c:out value='${saveTablesRequest.header.gamedate}'/>" readonly />
        </div>

        <div class="field">
          <label for="gameno">回</label>
          <input id="gameno" type="number" name="gameno"
                 value="<c:out value='${saveTablesRequest.header.gameno}'/>" readonly />
        </div>

        <div class="field">
          <label for="rate">レート</label>
          <div class="input-with-suffix">
            <input id="rate" type="number" name="rate"
                   value="<c:out value='${saveTablesRequest.header.rate}'/>" />
            <span class="suffix">ペソ</span>
          </div>
        </div>

        <div class="field field-pair">
          <label>配点／返し点</label>
          <div class="pair">
            <input type="number" name="points" aria-label="配点"
                   value="<c:out value='${saveTablesRequest.header.points}'/>" />
            <span class="pair-sep" aria-hidden="true">／</span>
            <input type="number" name="returnpoints" aria-label="返し点"
                   value="<c:out value='${saveTablesRequest.header.returnpoints}'/>" />
          </div>
        </div>

        <div class="field field-pair">
          <label>ウマ</label>
          <div class="pair">
            <input type="number" name="uma1" aria-label="ウマ1"
                   value="<c:out value='${saveTablesRequest.header.uma1}'/>" />
            <span class="pair-sep" aria-hidden="true">／</span>
            <input type="number" name="uma2" aria-label="ウマ2"
                   value="<c:out value='${saveTablesRequest.header.uma2}'/>" />
          </div>
        </div>
      </div>

      <div class="form-actions" aria-label="対局操作">
        <button id="calcBtn" type="button" class="action-btn calc">計算</button>
        <button id="saveBtn" type="button" class="action-btn save">登録</button>
      </div>
    </section>
  </form>

  <section class="tables-section" aria-label="対局結果入力">
    <u:matchTables
        players="${players}"
        initialRows="4"
        calcBtnId="calcBtn"
        saveBtnId="saveBtn"
        idPrefix="mt"
        saveTablesRequest="${saveTablesRequest}" />
  </section>

  <div id="tablesArea" class="mt"></div>

  <style>
    .alert{padding:10px 12px;border-radius:8px;margin:0 0 12px}
    .alert.success{background:#e8f5e9;color:#1b5e20}
    .alert.error{background:#fdecea;color:#b71c1c}

    .match-form,.tables-section{width:100%;max-width:1100px;margin:0 auto}
    .settings-card{padding:18px;background:#fff;border:1px solid #dfe3e8;border-radius:12px}
    .section-title{margin:0 0 14px;font-size:1.05rem;color:#263238}
    .settings-grid{display:grid;grid-template-columns:1.35fr .65fr 1fr 2fr 1.5fr;gap:14px;align-items:end}
    .field{min-width:0}
    .field label{display:block;margin:0 0 6px 2px;color:#4b5563;font-size:.9rem;font-weight:600}
    .match-form input[type="date"],.match-form input[type="number"]{
      width:100%;height:44px;padding:9px 12px;border:1px solid #cbd5e1;border-radius:8px;
      background:#fff;color:#111827;font-size:1rem
    }
    .match-form input[readonly]{background:#f3f4f6;color:#4b5563}
    .match-form input:focus{outline:3px solid rgba(37,99,235,.18);border-color:#2563eb}
    .input-with-suffix{position:relative}
    .input-with-suffix input{padding-right:44px!important}
    .input-with-suffix .suffix{position:absolute;right:11px;top:50%;transform:translateY(-50%);color:#6b7280;font-size:.82rem}
    .pair{display:grid;grid-template-columns:minmax(0,1fr) auto minmax(0,1fr);align-items:center;gap:7px}
    .pair-sep{color:#6b7280}

    .form-actions{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-top:16px}
    .action-btn{min-height:48px;padding:11px 16px;border:1px solid transparent;border-radius:9px;color:#fff;font-weight:700;cursor:pointer}
    .action-btn.calc{background:#1976d2}
    .action-btn.save{background:#2e7d32}
    .action-btn:hover{filter:brightness(.94)}
    .action-btn:focus-visible{outline:3px solid rgba(37,99,235,.28);outline-offset:2px}
    .action-btn:disabled{opacity:.6;cursor:not-allowed}

    .tables-section{margin-top:16px}
    .mt{margin-top:24px}

    @media(max-width:1050px){
      .settings-grid{grid-template-columns:1fr 1fr 1fr}
      .field-pair{grid-column:span 2}
    }

    @media(max-width:768px){
      .settings-card{padding:12px;border-radius:10px}
      .section-title{margin-bottom:10px}
      .settings-grid{grid-template-columns:minmax(0,1.5fr) minmax(88px,.5fr);gap:10px}
      .field:nth-child(3),.field-pair{grid-column:1/-1}
      .match-form input[type="date"],.match-form input[type="number"]{height:46px;font-size:16px}
      .form-actions{
        position:fixed;left:0;right:0;bottom:0;z-index:24;
        grid-template-columns:1fr 1fr;gap:10px;margin:0;padding:10px 12px;
        background:rgba(255,255,255,.97);border-top:1px solid #dfe3e8;
        box-shadow:0 -4px 16px rgba(15,23,42,.12)
      }
      .action-btn{min-height:48px}
      .tables-section{margin-top:12px}
    }
  </style>

</u:layout>
