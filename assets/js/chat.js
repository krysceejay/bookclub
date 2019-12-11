$(document).ready(function() {
  const chatdivh = $("#chat-body-id").prop("scrollHeight");
  chatDivScroll();
  chatDivChange();

  // $("#chatareaform").submit(function(){
  //   chatDivScrollT();
  // });
  // const hasFocus = $("#chat-area-input").is(":focus");
  // if (hasFocus) {
  //   chatDivScroll();
  // }

  function chatDivScroll() {
    $("#chat-body-id").scrollTop(chatdivh);
  }

  function chatDivScrollT() {
    setTimeout(function() {
      $("#chat-body-id").scrollTop(chatdivh);
    }, 100);
  }

  function chatDivChange() {
    $("#chat-body-id").bind("DOMSubtreeModified", function() {
      chatDivScrollT();
    });
  }

  $("#users-close-btn").click(function() {
    $(".chat-container-online-users").hide();
  });

  $("#online-users-show").click(function() {
    $(".chat-container-online-users").show();
  });

  $("#detail-close-btn").click(function() {
    $(".chat-container-bookdetails").hide();
  });

  $("#book-details-show").click(function() {
    $(".chat-container-bookdetails").show();
  });

  // $("#chat-area-input").focus(function() {

  // });
  $(window).resize(function() {
    chatDivScroll();
    chatDivChange();
  });

  $("#menu-bar-users").click(function() {
    $(".dropdown-content").toggleClass("display-element");
  });
});
