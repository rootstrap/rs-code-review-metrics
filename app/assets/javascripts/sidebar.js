
$(document).ready(function() {
  $('.time-period-select').select2();
  $( ".time-period-select" ).change(function(event) {
    window.location.replace(window.location.pathname + `?period=${event.target.value}`)
  });
});