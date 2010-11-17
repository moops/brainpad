jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} })

function _ajax_request(url, data, callback, type, method) {
  if (jQuery.isFunction(data)) {
    callback = data;
    data = {};
  }
  return jQuery.ajax({
    type: method,
    url: url,
    data: data,
    success: callback,
    dataType: type
  });
}

jQuery.extend({
  put: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'PUT');
  },
  delete_: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'DELETE');
  }
});

jQuery.fn.submitWithAjax = function() {
  this.unbind('submit', false);
  this.submit(function() {
    jQuery.post(this.action, $(this).serialize(), null, "script");
    return false;
  })

  return this;
};

jQuery.fn.getWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    jQuery.get($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.postWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    jQuery.post($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.putWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    jQuery.put($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.deleteWithAjax = function() {
  this.removeAttr('onclick');
  this.unbind('click', false);
  this.click(function() {
    jQuery.delete_($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

//This will "ajaxify" the links
function ajaxLinks(){
  jQuery('.ajaxForm').submitWithAjax();
  jQuery('a.get').getWithAjax();
  jQuery('a.post').postWithAjax();
  jQuery('a.put').putWithAjax();
  jQuery('a.delete').deleteWithAjax();
}

jQuery(document).ready(function() {

  //all non-GET requests will add the authenticity token in the data packet
  jQuery(document).ajaxSend(function(event, request, settings) {
    if (typeof(window.AUTH_TOKEN) == "undefined") return;
    // IE6 fix for http://dev.jquery.com/ticket/3155
    if (settings.type == 'GET' || settings.type == 'get') return;

    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
  });

  ajaxLinks(); 
    
  jQuery("#lavaLamp").lavaLamp({ fx: "easeOutBack", speed: 700});
  jQuery(".accordion").accordion();
  jQuery("input.calendar").datepicker();
  jQuery("input.calendar").datepicker("option", "dateFormat", "yy-mm-dd");
  jQuery("input.today").datepicker('setDate', new Date());
    
  $(".remote_edit_link").click(function() {
    // the id of the link needs to be of the form 'controller_id' i.e. 'workouts_123'
    var parts = this.id.split('_',2);
    $.get("/"+parts[0]+"/"+parts[1]+"/edit", null, null, "script");
      return false; 
  });
     
});

function openWindow(inWidth,inHeight,inName) {
  var options = "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,alwaysRaised=yes,width=" + inWidth + ",height=" + inHeight;
  var w = window.open("",inName,options);
  if (window.focus) {w.focus()}
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


