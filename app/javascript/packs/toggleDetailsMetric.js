$(document).on('turbolinks:load', function() {
  $('.details-button').click(function() {
    const metric = $(this.parentElement).next();
    const slideSpeed = 0;
    if (metric.css('display') === 'none') {
      metric.slideDown(slideSpeed);
      $(this).text('Hide details');
    } else {
      metric.slideUp(slideSpeed);
      $(this).text('View details');
    }
  });
});

$(document).on('turbolinks:load', function() {
  const canvas = document.getElementsByTagName('canvas').length;
  if(!canvas) {
    $('.details-button').hide();
  } else {
    $('.details-button').show();
  }

  $('[data-toggle="tooltip"]').tooltip();
});
