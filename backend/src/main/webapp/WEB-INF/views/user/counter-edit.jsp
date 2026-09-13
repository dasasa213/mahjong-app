<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="対局カウンター編集" active="${active}">

  <style>
    .counter-wrap {
      max-width: 1100px;
    }

    .counter-error {
      margin-bottom: 20px;
      padding: 10px 14px;
      border: 1px solid #e53935;
      border-radius: 4px;
      background: #ffebee;
      color: #c62828;
      font-weight: 600;
    }

    .counter-date {
      margin-bottom: 24px;
      font-size: 16px;
    }

    .counter-list {
      display: flex;
      gap: 28px;
      flex-wrap: wrap;
      align-items: center;
    }

    .counter-item {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .counter-label {
      font-weight: 600;
      min-width: 55px;
    }

    .counter-value {
      width: 55px;
      height: 38px;
      border: 1px solid #bbb;
      border-radius: 4px;
      text-align: center;
      font-size: 18px;
      background: #fff;
    }

    .counter-btn {
      width: 38px;
      height: 38px;
      border: 1px solid #aaa;
      border-radius: 4px;
      background: #fff;
      font-size: 22px;
      cursor: pointer;
    }

    .counter-btn:hover {
      background: #f1f1f1;
    }

    .button-area {
      margin-top: 28px;
      display: flex;
      gap: 12px;
    }

    .update-button {
      padding: 10px 28px;
      border: none;
      border-radius: 5px;
      background: #1976d2;
      color: #fff;
      font-size: 16px;
      cursor: pointer;
    }

    .back-button {
      padding: 10px 28px;
      border: 1px solid #aaa;
      border-radius: 5px;
      background: #fff;
      color: #333;
      text-decoration: none;
      font-size: 16px;
    }

    @media (max-width: 640px) {
      .counter-list {
        flex-direction: column;
        align-items: flex-start;
      }
    }
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
        alert("和了数は局数以下にしてください。");
        return false;
      }

      if (callCount > handCount) {
        alert("副露数は局数以下にしてください。");
        return false;
      }

      if (riichiCount > handCount) {
        alert("立直数は局数以下にしてください。");
        return false;
      }

      if (dealInCount > handCount) {
        alert("放銃数は局数以下にしてください。");
        return false;
      }

      return true;
    }
  </script>

</u:layout>