<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<t:layout title="アカウント登録" active="${active}">
  <!-- ページ専用CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/accounts.css"/>

  <section class="page-wrap">
    <h2 class="page-title">アカウント登録</h2>

    <c:if test="${not empty error}">
      <div class="alert alert-error" role="alert">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success" role="status">${success}</div>
    </c:if>

    <form class="form-card" action="${pageContext.request.contextPath}/admin/accounts" method="post" novalidate>
      <!-- 1行目：名前 -->
      <div class="form-field field-full">
        <label for="name" class="form-label">名前 <span class="req">*</span></label>
        <input id="name" name="name" type="text" class="input"
               required maxlength="10" autocomplete="name" />
        <small class="help">10文字以内</small>
      </div>

      <!-- 2行目：PWと確認を横並び -->
      <div class="form-field">
        <label for="password" class="form-label">パスワード <span class="req">*</span></label>
        <input id="password" name="password" type="password" class="input"
               required maxlength="10" autocomplete="new-password" />
        <small class="help">10文字以内</small>
      </div>

      <div class="form-field">
        <label for="passwordConfirm" class="form-label">パスワード（確認用） <span class="req">*</span></label>
        <input id="passwordConfirm" name="passwordConfirm" type="password" class="input"
               required maxlength="10" autocomplete="new-password" />
      </div>

      <!-- ボタン -->
      <div class="form-actions">
        <button type="submit" class="btn-primary">登録</button>
      </div>
    </form>

  </section>
</t:layout>
