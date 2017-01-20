$(function() {
  $('#reminder_form').on('shown.bs.modal', function () {
    $('#reminder_description').focus();
  });
});
