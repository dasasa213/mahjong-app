<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="対局カウンター編集" active="${active}">

  <style>
    .counter-wrap{width:100%;max-width:1100px;margin:0 auto;padding:16px;background:#fff;border:1px solid #dfe3e8;border-radius:12px}
    .counter-error{margin-bottom:14px;padding:10px 12px;border:1px solid #ef9a9a;border-radius:8px;background:#ffebee;color:#b71c1c;font-weight:600}
    .counter-date{display:inline-flex;margin-bottom:16px;padding:7px 11px;border-radius:8px;background:#eef6ef;color:#245c28;font-size:15px;font-weight:700}
    .counter-list{display:grid;grid-template-columns:repeat(5,minmax(145px,1fr));gap:12px}
    .counter-item{display:grid;grid-template-columns:44px 1fr 44px;grid-template-areas:"label label label" "minus value plus";gap:7px;padding:12px;border:1px solid #e2e8f0;border-radius:10px;background:#f8fafc}
    .counter-label{grid-area:label;text-align:center;font-weight:700;color:#334155}
    .counter-item .counter-btn:first-of-type{grid-area:minus}
    .counter-item .counter-value{grid-area:value}
    .counter-item .counter-btn:last-of-type{grid-area:plus}
    .counter-value{width:100%;height:46px;border:1px solid #cbd5e1;border-radius:8px;background:#fff;text-align:center;font-size:20px;font-weight:700}
    .counter-btn{width:44px;height:46px;border:1px solid #94a3b8;border-radius:8px;background:#fff;font-size:24px;cursor:pointer;touch-action:manipulation}
    .counter-btn:hover{background:#e8f5e9;border-color:#2e7d32}
    .counter-btn:active{transform:translateY(1px)}
    .button-area{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:18px}
    .update-button,.back-button{display:inline-flex;min-height:48px;align-items:center;justify-content:center;padding:10px 24px;border-radius:9px;font-size:16px;font-weight:700;cursor:pointer;text-decoration:none}
    .update-button{border:1px solid #2e7d32;background:#2e7d32;color:#fff}
    .back-button{border:1px solid #94a3b8;background:#fff;color:#334155}
    .counter-btn:focus-visible,.update-button:focus-visible,.back-button:focus-visible{outline:3px solid rgba(37,99,235,.24);outline-offset:2px}
    .custom-modal{display:none;position:fixed;z-index:9999;inset:0;padding:12px;background:rgba(15,23,42,.55);align-items:center;justify-content:center}
    .custom-modal-content{width:min(420px,100%);max-height:calc(100dvh - 24px);overflow:auto;background:#fff;border-radius:12px;padding:20px;box-shadow:0 20px 48px rgba(15,23,42,.3)}
    .custom-modal-title{margin-bottom:14px;font-size:18px;font-weight:700}
    .custom-modal-text{margin-bottom:20px;font-size:16px;line-height:1.6}
    .custom-modal-buttons{display:flex;justify-content:flex-end}
    .custom-modal-buttons button{min-height:44px;padding:8px 18px;border:0;border-radius:8px;background:#1976d2;color:#fff;cursor:pointer;font-size:15px;font-weight:600}
    @media(max-width:1000px){.counter-list{grid-template-columns:repeat(3,minmax(150px,1fr))}}
    @media(max-width:768px){
      .counter-wrap{padding:12px;border-radius:10px}
      .counter-list{grid-template-columns:repeat(2,minmax(0,1fr));gap:9px}
      .counter-item{grid-template-columns:44px minmax(48px,1fr) 44px;padding:10px 7px}
      .button-area{position:fixed;left:0;right:0;bottom:0;z-index:24;margin:0;padding:10px 12px;background:rgba(255,255,255,.97);border-top:1px solid #dfe3e8;box-shadow:0 -4px 16px rgba(15,23,42,.12)}
    }
    @media(max-width:380px){.counter-list{grid-template-columns:1fr}}
  </style>

  <div class="counter-wrap">

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
          action="${pageContext.request.contextPath}/user/counter/edit"
          onsubmit="return validateCounter();">

      <input type="hidden"
             name="id"
             value="${counter.id}">

      <div class="counter-list">

        <div class="counter-item">
          <span class="counter-label">局数</span>

          <button type="button"
                  class="counter-btn"
                  onclick="changeValue('handCount', -1)">
            -
          </button>

          <input id="handCount"
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

          <input id="winCount"
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

          <input id="callCount"
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

          <input id="riichiCount"
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

          <input id="dealInCount"
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

      <div class="button-area">

        <button type="submit"
                class="update-button">
          更新
        </button>

        <a href="${pageContext.request.contextPath}/user/counter"
           class="back-button">
          戻る
        </a>

      </div>

    </form>

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
                onclick="closeMessageModal();">
          OK
        </button>

      </div>

    </div>

  </div>
  <script>
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