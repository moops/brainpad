$(function() {
  $('.btn-show-accounts').click(function() {
    $('#payments-accounts').show();
    $('#payments-top-tags').hide();
  });
  $('.btn-show-top-tags').click(function() {
    $('#payments-accounts').hide();
    $('#payments-top-tags').show();
  });

  // payment hotkeys
  function docKeyUp(e) {
    // ctrl-a - click 'add payment' button
    if (e.ctrlKey && e.keyCode == 65) {
      $('#new-record-btn').click();
    }
    // ctrl-f - click 'find' button
    if (e.ctrlKey && e.keyCode == 70) {
      $('#find-btn').click();
    }
  }
  document.addEventListener('keydown', docKeyUp, false);

  $('#payment-form').on('shown.bs.modal', function () {
    $('#payment_amount').focus();
  });
});
