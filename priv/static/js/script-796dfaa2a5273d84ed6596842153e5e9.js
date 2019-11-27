$(document).ready(function() {
  $(".top_right-menu-icon").click(function() {
    $("#dashboard-main-aside").toggleClass("active-bar");
    $(".top_right-menu-icon").toggleClass("toggle");
  });
});
