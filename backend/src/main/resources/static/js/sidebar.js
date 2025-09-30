(function() {
  const sidebar = document.getElementById("sidebar");
  const toggle = document.getElementById("sidebar-toggle");
  const key = "sidebar.closed";

  // 前回状態を復元
  if (localStorage.getItem(key) === "true") {
    sidebar.classList.add("closed");
  }

  toggle.addEventListener("click", () => {
    sidebar.classList.toggle("closed");
    localStorage.setItem(key, sidebar.classList.contains("closed"));
  });
})();
