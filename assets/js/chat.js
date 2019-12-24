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

  //let display = "none";
  // sessionStorage.setItem("onlineUsers", "onlineusers");
  // if (sessionStorage.onlineUsers == "onlineusers") {
  //   alert("yes");
  // } else {
  //   alert("no");
  // }

  // $("#menu-bar-users").click(function() {
  //   $(".chat-container-online-users-sm").addClass("display-element");
  //   //sessionStorage.setItem("online-users", "onlineusers");
  //   //display = "block";
  //   // let bodyColor = $(".chat-container-online-users-sm").css("--userdisplay");
  //   // console.log(bodyColor);
  //   // $(".chat-container-online-users-sm").css("--userdisplay", "block");
  //   // let bodyColor = $(".chat-container-online-users-sm").css("--userdisplay");
  //   // console.log(bodyColor);
  // });

  // $("#users-close-btn-sm").click(function() {
  //   // display = "none";
  //   // $(".chat-container-online-users-sm").css("--userdisplay", "none");
  //   //if ($(".chat-container-online-users-sm").hasClass("display-element")) {
  //   $(".chat-container-online-users-sm").removeClass("display-element");
  //   //}
  //   // let bodyColor = $(".chat-container-online-users-sm").css("--userdisplay");
  //   // console.log(bodyColor);

  //   //sessionStorage.removeItem("online-users");
  // });

  //console.log(display);

  // if (sessionStorage.getItem("online-users") === "onlineusers") {
  //   $(".chat-container-online-users").addClass("display-element");
  // } else {
  //   alert("no");
  // }
});
