
$(document).ready(function() {
  const optSelected = $('select.period-selection').children("option:selected").val();
  if (optSelected === '') {
    const url = window.location.href.split('?')[0]
    window.history.replaceState({}, document.title, url);
  }

  $('.sidebar-form').change(function() {
    this.submit();
  })
});
