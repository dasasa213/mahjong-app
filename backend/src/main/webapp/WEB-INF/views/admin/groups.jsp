<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout title="グループ編集" active="${active}">
  <!-- ページ専用CSS：アカウント登録と同じものを使う -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/accounts.css"/>

  <section class="page-wrap">

    <c:if test="${not empty error}">
      <div class="alert alert-error" role="alert">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success" role="status">${success}</div>
    </c:if>

    <form class="form-card" action="${pageContext.request.contextPath}/admin/group/update" method="post" novalidate>

      <!-- 1行目：現在のグループ名（表示のみ） -->
      <div class="form-field field-full">
        <label class="form-label">現在のグループ名</label>
        <input type="text" class="input"
               value="${empty sessionScope.groupName ? '（未設定）' : sessionScope.groupName}"
               readonly />
      </div>

      <!-- 2行目：変更後のグループ名（入力） -->
      <div class="form-field field-full">
        <label for="newName" class="form-label">変更後のグループ名 <span class="req">*</span></label>
        <input id="newName" name="newName" type="text" class="input"
               required maxlength="10" placeholder="10文字以内"
               value="${form.newName}"/>
        <small class="help">10文字以内</small>
      </div>

      <!-- ボタン -->
      <div class="form-actions">
        <button type="submit" class="btn-primary">変更</button>
      </div>
    </form>

  </section>
</t:layout>
