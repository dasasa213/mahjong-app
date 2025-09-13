<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="active" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="sidebar" id="sidebar">
  <div class="menu-header">
    <span class="menu-title">メニュー</span>
    <button type="button" class="menu-toggle" id="sidebar-toggle" aria-label="サイドメニュー切替">☰</button>
  </div>

  <ul class="menu-items">
    <li class="${active=='admin-home' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/admin/home">管理者ホーム</a>
    </li>
    <li class="${active=='accounts' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/admin/accounts">アカウント登録</a>
    </li>
    <li class="${active=='groups' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/admin/group/edit">グループ編集</a>
    </li>
    <!-- 追加メニューはここに -->
  </ul>
</nav>
