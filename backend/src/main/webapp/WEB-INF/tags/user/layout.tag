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

  <div id="app-message-modal" class="app-modal" role="dialog" aria-modal="true"
       aria-labelledby="app-message-title" aria-describedby="app-message-text">
    <div class="app-modal-content">
      <h2 id="app-message-title" class="app-modal-title">お知らせ</h2>
      <p id="app-message-text" class="app-modal-text"></p>
      <div class="app-modal-actions">
        <button type="button" id="app-message-ok" class="app-modal-ok">OK</button>
      </div>
    </div>
  </div>

  <style>
    .app-modal{display:none;position:fixed;z-index:10000;inset:0;padding:12px;background:rgba(15,23,42,.55);align-items:center;justify-content:center}
    .app-modal.is-open{display:flex}
    .app-modal-content{width:min(420px,100%);max-height:calc(100dvh - 24px);overflow:auto;background:#fff;border-radius:12px;padding:20px;box-shadow:0 20px 48px rgba(15,23,42,.3)}
    .app-modal-title{margin:0 0 14px;font-size:18px;color:#1f2937}
    .app-modal-text{margin:0 0 20px;font-size:16px;line-height:1.6;white-space:pre-line}
    .app-modal-actions{display:flex;justify-content:flex-end;gap:10px}
    .app-modal-actions button{min-height:44px;padding:8px 18px;border:0;border-radius:8px;cursor:pointer;font-size:15px;font-weight:600}
    .app-modal-ok{background:#1976d2;color:#fff}
  </style>
  <script>
    (function(){
      const modal = document.getElementById('app-message-modal');
      const title = document.getElementById('app-message-title');
      const text = document.getElementById('app-message-text');
      const ok = document.getElementById('app-message-ok');
      let previousFocus = null;

      window.showAppMessage = function(message, heading){
        previousFocus = document.activeElement;
        title.textContent = heading || 'お知らせ';
        text.textContent = message || '';
        modal.classList.add('is-open');
        document.body.style.overflow = 'hidden';
        ok.focus();
      };
      window.closeAppMessage = function(){
        modal.classList.remove('is-open');
        document.body.style.overflow = '';
        if(previousFocus && previousFocus.focus) previousFocus.focus();
      };
      ok.addEventListener('click', window.closeAppMessage);
      modal.addEventListener('click', function(event){
        if(event.target === modal) window.closeAppMessage();
      });
      document.addEventListener('keydown', function(event){
        if(event.key === 'Escape' && modal.classList.contains('is-open')) window.closeAppMessage();
      });
    })();
  </script>
</body>
</html>
