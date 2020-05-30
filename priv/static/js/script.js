$(document).ready(function() {
  $(".top_right-menu-icon").click(function() {
    $("#dashboard-main-aside").toggleClass("active-bar");
    $(".top_right-menu-icon").toggleClass("toggle");
  });

  $("#show-pass").click(function() {
    if($(this). is(":checked")){
      //$("#user_passwordfield").attr('type') = "text";
      $("#user_passwordfield").prop('type', 'text');
      $("#eye-icon").removeClass("fa fa-eye-slash").addClass("fa fa-eye");
    }else{
      $("#user_passwordfield").prop('type', 'password');
      $("#eye-icon").removeClass("fa fa-eye").addClass("fa fa-eye-slash");
    }
  });

  // Get the modal
  //var modal = document.getElementById("myModal");

  // Get the button that opens the modal
  //var btn = document.getElementById("myBtn");

  // Get the <span> element that closes the modal
  //var span = document.getElementsByClassName("close")[0];

  $("#myBtn").click(function() {
    $("#myModal").css("display","block");
  });

  $("#closeModal").click(function() {
    $("#myModal").css("display","none");
  });

  $(window).click(function(e) {
      if ($(e.target).is("#myModal")) {
        $("#myModal").css("display","none");
      }

});

  // When the user clicks the button, open the modal
  // btn.onclick = function() {
  //   modal.style.display = "block";
  // }

  // When the user clicks on <span> (x), close the modal
  // span.onclick = function() {
  //   modal.style.display = "none";
  // }

  // When the user clicks anywhere outside of the modal, close it
  // window.onclick = function(event) {
  //   if (event.target == modal) {
  //     modal.style.display = "none";
  //   }
  // }

  const options1 = {
         series: [{
         name: 'Books',
         data: [2.3, 3.1, 4.0, 10.1]
       }],
         chart: {
         height: 350,
         width: '100%',
         type: 'bar',
       },
       plotOptions: {
         bar: {
           dataLabels: {
             position: 'top', // top, center, bottom
           },
         }
       },
       dataLabels: {
         enabled: true,
         formatter: function (val) {
           return val + "%";
         },
         offsetY: -20,
         style: {
           fontSize: '15px',
           colors: ["#304758"]
         }
       },

       xaxis: {
         categories: ["Public", "Private", "Completed", "Still Reading"],
         position: 'top',
         labels: {
           offsetY: -18,
           style: {
                fontSize: '16px'
            },

         },
         axisBorder: {
           show: false
         },
         axisTicks: {
           show: false
         },
         crosshairs: {
           fill: {
             type: 'gradient',
             gradient: {
               colorFrom: '#D8E3F0',
               colorTo: '#BED1E6',
               stops: [0, 100],
               opacityFrom: 0.4,
               opacityTo: 0.5,
             }
           }
         },
         tooltip: {
           enabled: true,
           offsetY: -35,

         }
       },
       fill: {
         gradient: {
           shade: 'light',
           type: "horizontal",
           shadeIntensity: 0.25,
           gradientToColors: undefined,
           inverseColors: true,
           opacityFrom: 1,
           opacityTo: 1,
           stops: [50, 0, 100, 100]

         },
         colors: ["#25A9FF"],
       },
       yaxis: {
         axisBorder: {
           show: false
         },
         axisTicks: {
           show: false,
         },
         labels: {
           show: true,
           formatter: function (val) {
             return val + "%";
           },
           style: {
                fontSize: '13px'
            }
         }

       },
       title: {
         text: 'Statistics Of Books Added',
         floating: true,
         offsetY: 320,
         align: 'center',
         style: {
           color: '#444',
           fontSize: '14px',
         }
       }
       };

       const chart1 = new ApexCharts(document.querySelector("#chart-books"), options1);
       chart1.render();

       //Pie chart

        const options2 = {
          series: [44, 55],
          chart: {
          type: 'donut',
        },
        responsive: [{
          breakpoint: 480,
          options: {
            chart: {
              width: 200
            },
            legend: {
              position: 'bottom'
            }
          }
        }],
        colors: ["#7BE8B6", "#FF4560"],
        };

        const chart2 = new ApexCharts(document.querySelector("#chart-readers"), options2);
        chart2.render();

});
