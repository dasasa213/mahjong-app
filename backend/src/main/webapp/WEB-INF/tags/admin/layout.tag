<%@ tag description="Base layout for admin" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="active" required="false" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/admin" %>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>${empty title ? "管理画面" : title}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css?v=5" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css?v=3" />
  <script defer src="${pageContext.request.contextPath}/js/sidebar.js?v=2"></script>
</head>
<body>
  <a:sidebar active="${active}" />

  <button type="button"
          class="mobile-menu-toggle"
          id="mobile-menu-toggle"
          aria-label="メニューを開く"
          aria-controls="sidebar"
          aria-expanded="false">☰</button>
  <div class="sidebar-backdrop" id="sidebar-backdrop" aria-hidden="true"></div>

  <main class="content">
    <a:header title="${empty title ? '画面タイトル' : title}" />

    <section class="page-body">
      <jsp:doBody />
    </section>
  </main>
</body>
</html>
