$(document).ready(function() {
  $(".top_right-menu-icon").click(function() {
    $("#dashboard-main-aside").toggleClass("active-bar");
    $(".top_right-menu-icon").toggleClass("toggle");
  });

  // $('*[id^="rt-"]').click(function() {
  //   let strnum = $(this).attr('num');
  //   //let strid = $(this).attr('id');
  //   if (strnum == 2) {
  //     $("#rt-1").toggleClass("fill");
  //     $("#rt-2").toggleClass("fill");
  //   }
  //   if (strnum == 3) {
  //     $("#rt-1").toggleClass("fill");
  //     $("#rt-2").toggleClass("fill");
  //     $("#rt-3").toggleClass("fill");
  //   }
  //   if (strnum == 4) {
  //     $("#rt-1").toggleClass("fill");
  //     $("#rt-2").toggleClass("fill");
  //     $("#rt-3").toggleClass("fill");
  //     $("#rt-4").toggleClass("fill");
  //   }
  //   if (strnum == 5) {
  //     $("#rt-1").toggleClass("fill");
  //     $("#rt-2").toggleClass("fill");
  //     $("#rt-3").toggleClass("fill");
  //     $("#rt-4").toggleClass("fill");
  //     $("#rt-5").toggleClass("fill");
  //   }
  //   //$("#"+strid).toggleClass("fill");
  //   //alert(strid);
  // });

});
