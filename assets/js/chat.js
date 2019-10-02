$(document).ready(function(){
  chatDivScroll();

  $("#chatareaform").submit(function(){
    chatDivScrollT();
  });

  function chatDivScroll(){
      const chatdivh = $("#chat-body-id").prop('scrollHeight');
      $("#chat-body-id").scrollTop(chatdivh);
  }

  function chatDivScrollT(){
      const chatdivh = $("#chat-body-id").prop('scrollHeight');
      //const chath = $("#chat-body-id").height();
      setTimeout(function(){
         $("#chat-body-id").scrollTop(chatdivh);
       }, 100);
     }

     $("#users-close-btn").click(function () {
       $(".chat-container-online-users").hide();
     });

     $("#online-users-show").click(function () {
       $(".chat-container-online-users").show();
     });

     $("#detail-close-btn").click(function () {

       $(".chat-container-bookdetails").hide();
     });

     $("#book-details-show").click(function () {

       $(".chat-container-bookdetails").show();
     });

});
