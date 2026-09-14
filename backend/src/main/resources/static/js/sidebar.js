(function () {
  const sidebar = document.getElementById("sidebar");
  const desktopToggle = document.getElementById("sidebar-toggle");
  const mobileToggle = document.getElementById("mobile-menu-toggle");
  const backdrop = document.getElementById("sidebar-backdrop");
  const desktopKey = "sidebar.closed";
  const mobileQuery = window.matchMedia("(max-width: 768px)");

  if (!sidebar) {
    return;
  }

  function isMobile() {
    return mobileQuery.matches;
  }

  function setMobileOpen(open) {
    sidebar.classList.toggle("mobile-open", open);
    document.body.classList.toggle("menu-open", open);
    if (backdrop) {
      backdrop.classList.toggle("visible", open);
      backdrop.setAttribute("aria-hidden", String(!open));
    }
    if (mobileToggle) {
      mobileToggle.setAttribute("aria-expanded", String(open));
      mobileToggle.setAttribute("aria-label", open ? "メニューを閉じる" : "メニューを開く");
    }
  }

  function applyLayoutMode() {
    if (isMobile()) {
      sidebar.classList.remove("closed");
      setMobileOpen(false);
    } else {
      setMobileOpen(false);
      sidebar.classList.toggle("closed", localStorage.getItem(desktopKey) === "true");
    }
  }

  if (desktopToggle) {
    desktopToggle.addEventListener("click", function () {
      if (isMobile()) {
        setMobileOpen(false);
        return;
      }
      sidebar.classList.toggle("closed");
      localStorage.setItem(desktopKey, String(sidebar.classList.contains("closed")));
    });
  }

  if (mobileToggle) {
    mobileToggle.addEventListener("click", function () {
      setMobileOpen(!sidebar.classList.contains("mobile-open"));
    });
  }

  if (backdrop) {
    backdrop.addEventListener("click", function () {
      setMobileOpen(false);
    });
  }

  sidebar.querySelectorAll("a").forEach(function (link) {
    link.addEventListener("click", function () {
      if (isMobile()) {
        setMobileOpen(false);
      }
    });
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && sidebar.classList.contains("mobile-open")) {
      setMobileOpen(false);
      if (mobileToggle) {
        mobileToggle.focus();
      }
    }
  });

  if (typeof mobileQuery.addEventListener === "function") {
    mobileQuery.addEventListener("change", applyLayoutMode);
  } else {
    mobileQuery.addListener(applyLayoutMode);
  }

  applyLayoutMode();
})();
