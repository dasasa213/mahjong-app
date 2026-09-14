<%@ tag description="Base layout for user" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="active" required="false" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${empty title ? "利用者画面" : title}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css?v=4" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css?v=2" />
  <script defer src="${pageContext.request.contextPath}/js/sidebar.js?v=2"></script>
</head>
<body>
  <u:userSidebar active="${active}" />

  <button type="button"
          class="mobile-menu-toggle"
          id="mobile-menu-toggle"
          aria-label="メニューを開く"
          aria-controls="sidebar"
          aria-expanded="false">☰</button>
  <div class="sidebar-backdrop" id="sidebar-backdrop" aria-hidden="true"></div>

  <main class="content">
    <u:userHeader title="${empty title ? '画面タイトル' : title}" />

    <section class="page-body">
      <jsp:doBody />
    </section>
  </main>
</body>
</html>
