export const detailRowBuilder = (data, metric) => {
  $('#modal-details').empty();

  $.each(data, function (i, item) {
    $('#modal-details')
      .append(createLinkElement(item.html_url))
      .append(createSpanElement(item.value, metric))
      .append(document.createElement('br'));
  });
};

const createLinkElement = (htmlUrl) => {
  const link = $('<a />').prop({
                  target: '_blank',
                  href: htmlUrl,
                  innerText: htmlUrl
                });

  return link;
}

const createSpanElement = (value, metric) => {
  const span = $('<span />');
  span.addClass('hours-pr');
  span.text(`  (${value} ${metric})`);

  return span;
}