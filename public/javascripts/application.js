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
