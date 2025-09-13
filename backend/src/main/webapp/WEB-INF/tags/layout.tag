<%@ tag description="Base layout with sidebar" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="false" %>
<%@ attribute name="active" required="false" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
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
  <!-- 左サイドバー -->
  <div class="sidebar" id="sidebar">
    <div class="menu-header">
      <span class="menu-title">メニュー</span>
      <button id="sidebar-toggle" class="menu-toggle">☰</button>
    </div>
    <ul class="menu-items">
      <li class="${active=='admin-home' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/admin/home">管理者ホーム</a>
      </li>
      <li class="${active=='accounts' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/admin/accounts">アカウント登録</a>
      </li>
      <li class="${active=='groups' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/admin/groups">グループ編集</a>
      </li>
    </ul>
  </div>

  <!-- 右コンテンツ -->
  <main class="content">
    <!-- ★ 共通ヘッダ（タイトル左／ユーザ情報右） -->
    <t:header title="${empty title ? '画面タイトル' : title}" />

    <!-- 画面本体 -->
    <section class="page-body">
      <jsp:doBody />
    </section>
  </main>
</body>
</html>
