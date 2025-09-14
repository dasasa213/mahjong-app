<%@ tag description="Base layout for admin" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="active" required="false" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/admin" %>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8" />
  <title>${empty title ? "管理画面" : title}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css?v=3" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css?v=1" />
  <script defer src="${pageContext.request.contextPath}/js/sidebar.js"></script>
</head>
<body>
  <!-- 左サイドバー（admin 用） -->
  <a:sidebar active="${active}" />

  <!-- 右コンテンツ -->
  <main class="content">
    <!-- 共通ヘッダ -->
    <a:header title="${empty title ? '画面タイトル' : title}" />

    <section class="page-body">
      <jsp:doBody />
    </section>
  </main>
</body>
</html>
