$(function() {
  $('.btn-show-accounts').click(function() {
    $(this).addClass('active');
    $('.btn-show-top-tags').removeClass('active');
    $('#payments-accounts').removeClass('d-none');
    $('#payments-top-tags').addClass('d-none');;
  });
  $('.btn-show-top-tags').click(function() {
    $(this).addClass('active');
    $('.btn-show-accounts').removeClass('active');
    $('#payments-accounts').addClass('d-none');
    $('#payments-top-tags').removeClass('d-none');
  });

  $('#payment_form').on('shown.bs.modal', function () {
    $('#payment_amount').focus();
  });
});
