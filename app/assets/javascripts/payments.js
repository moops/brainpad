$(function() {
  $('.btn-show-accounts').click(function() {
    $('#payments_accounts').show();
    $('#payments_top_tags').hide();
  });
  $('.btn-show-top-tags').click(function() {
    $('#payments_accounts').hide();
    $('#payments_top_tags').show();
  });

  $('#payment_form').on('shown.bs.modal', function () {
    $('#payment_amount').focus();
  });
});
