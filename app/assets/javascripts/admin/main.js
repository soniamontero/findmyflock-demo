jQuery(function($) {
  $(".edit_match").change(function() {
    $(this).closest('.edit_match').find('input[type=submit]').removeClass('hidden');
  });
});
