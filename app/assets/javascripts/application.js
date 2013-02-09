//js in gems
//= require jquery
//= require jquery_ujs
//= require jquery.easing
//= require bootstrap
//= require bootstrap-datepicker
//= require_tree .


//build a form dialog
function buildFormDialog(name) {
  var f = jQuery('#' + name + '_form').dialog({ autoOpen: false, width: 600, title: name + ' form', modal: true, show: 'fade' });
  $('.show_' + name + '_form').click(function() {
    f.dialog('open');
    return false;
  });
}

//validate a form
function validate(form_id) {
  $('#' + form_id).validate({
        errorPlacement: function(error, element) {
          jQuery(element).attr('title', jQuery(error).html());
          jQuery(element).tooltip();
        }
  });
}

$(document).ready(function() {
  $('#nav').spasticNav();
  $("#logoutlink").tooltip();
  $(".accordion").accordion();
  $("input.calendar").datepicker();
  $("input.calendar").datepicker("option", "dateFormat", "yy-mm-dd");
  $("input.today").datepicker('setDate', new Date());
  
  $(".toggle_search_form").click(function() {
    $('.search_form').toggle('fast', 'swing', null)
  });
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


