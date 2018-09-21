jQuery(function($) {
  $(".dropdown").change(function() {
    var rowValue = $(this).closest('.dropdown').find('option:selected').val();
    console.log('selected', rowValue);

    $(this).closest('tr').addClass('email');
  });
});
