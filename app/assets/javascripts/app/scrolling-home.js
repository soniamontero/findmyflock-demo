jQuery(function($) {
  $("#down-blue-arrow").click(function(event) {
    $('html, body').animate({
      scrollTop: $("#section-02").offset().top - 60
    }, 1300);
  });
});
