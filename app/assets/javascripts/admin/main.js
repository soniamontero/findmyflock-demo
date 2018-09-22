jQuery(function($) {
  $(".dropdown").change(function() {
    $(this).closest('.dropdown').find('input[type=submit]').removeClass('hidden');
  });
});
