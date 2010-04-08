function openWindow(inWidth,inHeight,inName) {
  var options = "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,alwaysRaised=yes,width=" + inWidth + ",height=" + inHeight;
  var w = window.open("",inName,options);
  if (window.focus) {w.focus()}
}
