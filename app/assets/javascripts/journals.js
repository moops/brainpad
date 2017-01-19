$(function() {
  // journal hotkeys
  function docKeyUp(e) {
    // ctrl-a - click 'add workout' button
    if (e.ctrlKey && e.keyCode == 65) {
      $('#new-record-btn').click();
    }
    // ctrl-f - click 'find' button
    if (e.ctrlKey && e.keyCode == 70) {
      $('#find-btn').click();
    }
  }
  document.addEventListener('keydown', docKeyUp, false);

  $('#journal-form').on('shown.bs.modal', function () {
    $('#journal_entry').focus();
  });
});
