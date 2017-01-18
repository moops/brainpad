//= require jquery
//= require jquery_ujs
//= require jquery.easing
//= require bootstrap
//= require flatpickr
//= require_tree .

$(function() {
  $('#nav').spasticNav();
  $("a.tip").tooltip();

  $('#search-container').on('shown.bs.collapse', function () {
    $('#search-query').focus();
  });

  $('#login-form').on('shown.bs.collapse', function () {
    $('#username').focus();
  });

  $('#registration-form').on('shown.bs.collapse', function () {
    $('#person_username').focus();
  });

  flatpickr(".flatpickr", {
    enableTime: true,
    allowInput: true
  });

  // google analytics
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-83838015-1', 'auto');
  ga('send', 'pageview');
  ga('send', 'event', { 'eventCategory': 'raceweb-cat', 'eventAction': 'raceweb-action', 'eventValue': 'raceweb-val' });
});

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

  if(min < 10) {
    min = "0" + min;
  }
  if(sec < 10) {
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

// hide success messages after 3 seconds
window.setTimeout(function() {
    $(".alert-success").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove();
    });
}, 3000);
