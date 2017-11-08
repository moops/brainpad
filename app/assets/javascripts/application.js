//= require rails-ujs
//= require jquery3
//= require jquery.easing
//= require popper
//= require bootstrap
//= require flatpickr
//= require_tree .

$(function() {
  $('#nav').spasticNav();
  $('a.tip').tooltip();

  // focus
  $('#modal-dialog').on('shown.bs.modal', function () {
    $('.focus').focus();
  });

  $('#search-container').on('shown.bs.collapse', function () {
    $('#search-query').focus();
  });

  // hotkeys
  document.addEventListener('keydown', function(e) {
    // submit the form if return key in form
    if (e.keyCode == 13) {
      $(e.target).parents('form').submit();
    }
    // ctrl-a - click 'add record' button
    if (e.ctrlKey && e.keyCode == 65) {
      $('#new-record-btn')[0].click();
    }
    // ctrl-f - click 'find' button
    if (e.ctrlKey && e.keyCode == 70) {
      $('#find-btn').click();
    }
  }, false);
});

function addMessage(kind, message) {
  var foo = $('<div class="alert col-12 alert-dismissible alert-success">' +
    '  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
    '  <strong>' + kind + '</strong>: ' + message +
    '</div>');
  $('#messages').append(foo);
}

function count(id,until) {
  var val = "";
  var now = new Date();
  var then = new Date(until);
  var duration = Math.abs((then - now) / 1000);
  var yrs = Math.floor(duration /31536000);
  var day = Math.floor((duration % 31536000) / 86400);
  var hr = Math.floor((duration % 86400) / 3600);
  var min = Math.floor((duration % 3600) / 60);
  var sec = Math.floor(duration % 60);

  if (min < 10) {
    min = "0" + min;
  }
  if (sec < 10) {
    sec = "0" + sec;
  }
  if (yrs > 0) {
    val += yrs + (yrs > 1 ? " years " : " year ");
  }
  if (day > 0) {
    val += day + (day > 1 ? " days " : " day ");
  }
  val += (hr > 0 ? hr + ":" :"");
  val += (min > 0 ? min + ":" :"") + sec;

  if (then < now) {
    val += " ago";
  }

  document.getElementById(id).value = val;
  setTimeout("count('" + id + "','" + until + "')", 1000);
}

// hide messages after 3 seconds
window.setInterval(function() {
  $("[class^=alert]").fadeTo(500, 0).slideUp(500, function() {
    $(this).remove();
  });
}, 5000);
