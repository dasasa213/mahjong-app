<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="userId" required="false" %>
<%@ attribute name="userName" required="false" %>
<%@ attribute name="groupName" required="false" %>

<header class="app-header">
  <h1 class="app-header__title">${title}</h1>
  <div class="app-header__right">
    <span class="app-header__user">
      ${userId != null ? userId : sessionScope.userId} ：
      ${userName != null ? userName : sessionScope.userName} ：
      <span class="app-header__group">
        ${groupName != null ? groupName : sessionScope.groupName}
      </span>
    </span>
    <a class="app-header__logout" href="${pageContext.request.contextPath}/main/logout">ログアウト</a>
  </div>
</header>
