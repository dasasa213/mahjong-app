<%@ tag pageEncoding="UTF-8" %>
<%@ attribute name="active" required="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="sidebar" id="sidebar">
  <div class="menu-header">
    <span class="menu-title">メニュー</span>
    <button type="button" class="menu-toggle" id="sidebar-toggle" aria-label="サイドメニュー切替">☰</button>
  </div>

  <ul class="menu-items">
    <li class="${active=='user-home' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/user/home">利用者ホーム</a>
    </li>
    <li class="${active=='matches-new' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/user/matches/new">新規対局</a>
    </li>
    <li class="${active=='matches-edit' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/user/matches/edit">対局編集</a>
    </li>
    <li class="${active=='stats' ? 'active' : ''}">
      <a href="${pageContext.request.contextPath}/user/overall">総合成績</a>
    </li>
    <!-- 追加メニューはここに -->
  </ul>
</nav>
