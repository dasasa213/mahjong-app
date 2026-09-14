<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="対局カウンター" active="${active}">

  <style>
    .counter-wrap,.counter-history{width:100%;max-width:1100px;margin-inline:auto}
    .counter-wrap{padding:16px;background:#fff;border:1px solid #dfe3e8;border-radius:12px}
    .counter-date{display:inline-flex;margin-bottom:16px;padding:7px 11px;border-radius:8px;background:#eef6ef;color:#245c28;font-size:15px;font-weight:700}
    .counter-list{display:grid;grid-template-columns:repeat(5,minmax(145px,1fr));gap:12px;align-items:stretch}
    .counter-item{display:grid;grid-template-columns:44px 1fr 44px;grid-template-areas:"label label label" "minus value plus";gap:7px;padding:12px;border:1px solid #e2e8f0;border-radius:10px;background:#f8fafc}
    .counter-label{grid-area:label;min-width:0;text-align:center;font-weight:700;color:#334155}
    .counter-item .counter-btn:first-of-type{grid-area:minus}
    .counter-item .counter-value{grid-area:value}
    .counter-item .counter-btn:last-of-type{grid-area:plus}
    .counter-value{width:100%;height:46px;border:1px solid #cbd5e1;border-radius:8px;background:#fff;text-align:center;font-size:20px;font-weight:700;color:#111827}
    .counter-btn{width:44px;height:46px;border:1px solid #94a3b8;border-radius:8px;background:#fff;color:#1f2937;font-size:24px;cursor:pointer;touch-action:manipulation}
    .counter-btn:hover{background:#e8f5e9;border-color:#2e7d32}
    .counter-btn:active{transform:translateY(1px)}
    .counter-btn:focus-visible,.counter-submit:focus-visible,.edit-btn:focus-visible,.delete-btn:focus-visible{outline:3px solid rgba(37,99,235,.24);outline-offset:2px}
    .counter-submit{display:block;width:min(360px,100%);min-height:48px;margin:18px auto 0;padding:10px 28px;border:0;border-radius:9px;background:#2e7d32;color:#fff;font-size:16px;font-weight:700;cursor:pointer}
    .counter-submit:hover{filter:brightness(.94)}
    .counter-error,.counter-success{margin-bottom:14px;padding:10px 12px;border-radius:8px;font-weight:600}
    .counter-error{border:1px solid #ef9a9a;background:#ffebee;color:#b71c1c}
    .counter-success{border:1px solid #81c784;background:#e8f5e9;color:#1b5e20}

    .counter-history{margin-top:16px;background:#fff;border:1px solid #dfe3e8;border-radius:12px;overflow-x:auto;overscroll-behavior-inline:contain;-webkit-overflow-scrolling:touch}
    .counter-history h3{position:sticky;left:0;width:max-content;min-width:100%;box-sizing:border-box;margin:0;padding:14px 16px;border-bottom:1px solid #e5e7eb;font-size:1.05rem}
    .history-table{width:100%;min-width:760px;border-collapse:separate;border-spacing:0}
    .history-table th,.history-table td{padding:10px 12px;border-right:1px solid #e5e7eb;border-bottom:1px solid #e5e7eb;text-align:center;white-space:nowrap}
    .history-table th{background:#2e7d32;color:#fff}
    .history-table th:first-child,.history-table td:first-child{position:sticky;left:0;min-width:120px}
    .history-table th:first-child{z-index:3;background:#256b2a}
    .history-table td:first-child{z-index:2;background:#fff;box-shadow:2px 0 4px rgba(15,23,42,.08)}
    .history-table tbody tr:nth-child(even) td{background:#f8fafc}
    .history-table tbody tr:nth-child(even) td:first-child{background:#f8fafc}
    .history-actions{white-space:nowrap}
    .delete-form{display:inline}
    .edit-btn,.delete-btn{display:inline-flex;min-height:40px;align-items:center;justify-content:center;margin:0 3px;padding:7px 11px;border-radius:7px;cursor:pointer;text-decoration:none;font-weight:600}
    .edit-btn{border:1px solid #93c5fd;background:#fff;color:#1d4ed8}
    .delete-btn{border:1px solid #dc2626;background:#dc2626;color:#fff}

    .custom-modal{display:none;position:fixed;z-index:9999;inset:0;padding:12px;background:rgba(15,23,42,.55);align-items:center;justify-content:center}
    .custom-modal-content{width:min(420px,100%);max-height:calc(100dvh - 24px);overflow:auto;background:#fff;border-radius:12px;padding:20px;box-shadow:0 20px 48px rgba(15,23,42,.3)}
    .custom-modal-title{margin-bottom:14px;font-size:18px;font-weight:700}
    .custom-modal-text{margin-bottom:20px;font-size:16px;line-height:1.6}
    .custom-modal-buttons{display:flex;justify-content:flex-end;gap:10px}
    .custom-modal-buttons button{min-height:44px;padding:8px 18px;border:0;border-radius:8px;cursor:pointer;font-size:15px;font-weight:600}
    .modal-ok-button{background:#1976d2;color:#fff}
    .modal-cancel-button{background:#e5e7eb;color:#1f2937}

    @media(max-width:1000px){
      .counter-list{grid-template-columns:repeat(3,minmax(150px,1fr))}
    }
    @media(max-width:768px){
      .counter-wrap{padding:12px;border-radius:10px}
      .counter-list{grid-template-columns:repeat(2,minmax(0,1fr));gap:9px}
      .counter-item{grid-template-columns:44px minmax(48px,1fr) 44px;padding:10px 7px}
      .counter-submit{position:sticky;bottom:74px;z-index:4;width:100%;box-shadow:0 4px 14px rgba(15,23,42,.16)}
      .counter-history{border-radius:10px}
      .history-table th,.history-table td{padding:9px 8px}
      .edit-btn,.delete-btn{min-height:44px}
    }
    @media(max-width:380px){
      .counter-list{grid-template-columns:1fr}
    }
  </style>

  <div class="counter-wrap">

    <c:if test="${not empty success}">
      <div class="counter-success">
        <c:out value="${success}" />
      </div>
    </c:if>

    <c:if test="${not empty error}">
      <div class="counter-error">
        <c:out value="${error}" />
      </div>
    </c:if>

    <div class="counter-date">
      対局日：
      <c:out value="${counter.gameDate}" />
    </div>

    <form method="post"
          action="${pageContext.request.contextPath}/user/counter"
          onsubmit="return validateCounter();">

      <div class="counter-list">

        <div class="counter-item">
          <span class="counter-label">局数</span>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('handCount', -1)">
            -
          </button>

          <input
              id="handCount"
              name="handCount"
              class="counter-value"
              type="number"
              value="${counter.handCount}"
              min="0"
              readonly>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('handCount', 1)">
            +
          </button>
        </div>

        <div class="counter-item">
          <span class="counter-label">和了数</span>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('winCount', -1)">
            -
          </button>

          <input
              id="winCount"
              name="winCount"
              class="counter-value"
              type="number"
              value="${counter.winCount}"
              min="0"
              readonly>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('winCount', 1)">
            +
          </button>
        </div>

        <div class="counter-item">
          <span class="counter-label">副露数</span>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('callCount', -1)">
            -
          </button>

          <input
              id="callCount"
              name="callCount"
              class="counter-value"
              type="number"
              value="${counter.callCount}"
              min="0"
              readonly>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('callCount', 1)">
            +
          </button>
        </div>

        <div class="counter-item">
          <span class="counter-label">立直数</span>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('riichiCount', -1)">
            -
          </button>

          <input
              id="riichiCount"
              name="riichiCount"
              class="counter-value"
              type="number"
              value="${counter.riichiCount}"
              min="0"
              readonly>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('riichiCount', 1)">
            +
          </button>
        </div>

        <div class="counter-item">
          <span class="counter-label">放銃数</span>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('dealInCount', -1)">
            -
          </button>

          <input
              id="dealInCount"
              name="dealInCount"
              class="counter-value"
              type="number"
              value="${counter.dealInCount}"
              min="0"
              readonly>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('dealInCount', 1)">
            +
          </button>
        </div>

      </div>

      <button type="submit"
              class="counter-submit">
        登録
      </button>
    </form>
  </div>

  <div class="counter-history">

    <h3>登録履歴</h3>

    <table class="history-table">
      <thead>
        <tr>
          <th>日付</th>
          <th>局数</th>
          <th>和了数</th>
          <th>副露数</th>
          <th>立直数</th>
          <th>放銃数</th>
          <th>操作</th>
        </tr>
      </thead>

      <tbody>

        <c:forEach var="row" items="${history}">
          <tr>
            <td><c:out value="${row.gameDate}" /></td>
            <td><c:out value="${row.handCount}" /></td>
            <td><c:out value="${row.winCount}" /></td>
            <td><c:out value="${row.callCount}" /></td>
            <td><c:out value="${row.riichiCount}" /></td>
            <td><c:out value="${row.dealInCount}" /></td>

            <td class="history-actions">

              <a class="edit-btn"
                 href="${pageContext.request.contextPath}/user/counter/edit?id=${row.id}">
                編集
              </a>

              <form method="post"
                    action="${pageContext.request.contextPath}/user/counter/delete"
                    class="delete-form"
                    onsubmit="return showDeleteConfirm(this);">

                <input type="hidden"
                       name="id"
                       value="${row.id}">

                <button type="submit"
                        class="delete-btn">
                  削除
                </button>

              </form>

            </td>
          </tr>
        </c:forEach>

      </tbody>
    </table>

  </div>
  <div id="messageModal" class="custom-modal">
    <div class="custom-modal-content">

      <div class="custom-modal-title">
        入力内容を確認してください
      </div>

      <div id="messageModalText"
           class="custom-modal-text">
      </div>

      <div class="custom-modal-buttons">
        <button type="button"
                class="modal-ok-button"
                onclick="closeMessageModal();">
          OK
        </button>
      </div>

    </div>
  </div>


  <div id="deleteConfirmModal" class="custom-modal">
    <div class="custom-modal-content">

      <div class="custom-modal-title">
        登録履歴の削除
      </div>

      <div class="custom-modal-text">
        この履歴を削除してもよろしいですか？
      </div>

      <div class="custom-modal-buttons">

        <button type="button"
                class="modal-cancel-button"
                onclick="closeDeleteConfirm();">
          キャンセル
        </button>

        <button type="button"
                class="modal-ok-button"
                onclick="executeDelete();">
          OK
        </button>

      </div>

    </div>
  </div>
    <script>
      let deleteForm = null;

      function changeValue(id, diff) {

        const input = document.getElementById(id);

        let value = parseInt(input.value || "0", 10);

        value += diff;

        if (value < 0) {
          value = 0;
        }

        input.value = value;
      }


      function showMessage(message) {

        document.getElementById("messageModalText").textContent = message;

        document.getElementById("messageModal").style.display = "flex";
      }


      function closeMessageModal() {

        document.getElementById("messageModal").style.display = "none";
      }


      function showDeleteConfirm(form) {

        deleteForm = form;

        document.getElementById("deleteConfirmModal").style.display = "flex";

        return false;
      }


      function closeDeleteConfirm() {

        document.getElementById("deleteConfirmModal").style.display = "none";

        deleteForm = null;
      }


      function executeDelete() {

        if (deleteForm === null) {
          return;
        }

        const form = deleteForm;

        deleteForm = null;

        document.getElementById("deleteConfirmModal").style.display = "none";

        form.submit();
      }


      function validateCounter() {

        const handCount =
            parseInt(document.getElementById("handCount").value || "0", 10);

        const winCount =
            parseInt(document.getElementById("winCount").value || "0", 10);

        const callCount =
            parseInt(document.getElementById("callCount").value || "0", 10);

        const riichiCount =
            parseInt(document.getElementById("riichiCount").value || "0", 10);

        const dealInCount =
            parseInt(document.getElementById("dealInCount").value || "0", 10);


        if (winCount > handCount) {

          showMessage("和了数は局数以下にしてください。");

          return false;
        }


        if (callCount > handCount) {

          showMessage("副露数は局数以下にしてください。");

          return false;
        }


        if (riichiCount > handCount) {

          showMessage("立直数は局数以下にしてください。");

          return false;
        }


        if (dealInCount > handCount) {

          showMessage("放銃数は局数以下にしてください。");

          return false;
        }


        return true;
      }
    </script>
</u:layout>