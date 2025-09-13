<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html><html lang="ja"><head><meta charset="UTF-8"><title>管理者ホーム（仮）</title></head>
<body>
<h2>管理者ホーム（仮）</h2>
<p>ようこそ、<%= session.getAttribute("userName") %> さん（ADMIN）</p>
<p><a href="<%= request.getContextPath() %>/logout">ログアウト</a></p>
</body></html>
