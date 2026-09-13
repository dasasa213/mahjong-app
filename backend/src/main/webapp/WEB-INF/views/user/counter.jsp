<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="対局カウンター" active="${active}">

  <style>
    .counter-wrap {
      max-width: 1100px;
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

    .counter-submit {
      margin-top: 28px;
      padding: 10px 28px;
      border: none;
      border-radius: 5px;
      background: #1976d2;
      color: #fff;
      font-size: 16px;
      cursor: pointer;
    }

    @media (max-width: 640px) {
      .counter-list {
        flex-direction: column;
        align-items: flex-start;
      }
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

    .counter-success {
      margin-bottom: 20px;
      padding: 10px 14px;
      border: 1px solid #2e7d32;
      border-radius: 4px;
      background: #e8f5e9;
      color: #2e7d32;
      font-weight: 600;
    }

    .counter-history {
      margin-top: 40px;
    }

    .history-table {
      width: 100%;
      max-width: 900px;
      border-collapse: collapse;
    }

    .history-table th,
    .history-table td {
      border: 1px solid #ddd;
      padding: 8px 12px;
      text-align: center;
    }

    .history-table th {
      background: #2e7d32;
      color: white;
    }

    .history-actions {
      white-space: nowrap;
    }

    .delete-form {
      display: inline;
    }

    .edit-btn,
    .delete-btn {
      margin: 0 3px;
      padding: 5px 10px;
      cursor: pointer;
    }

    .delete-btn {
      color: #fff;
      background: #e53935;
      border: none;
      border-radius: 4px;
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
                    onsubmit="return confirm('この履歴を削除してもよろしいですか？');">

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