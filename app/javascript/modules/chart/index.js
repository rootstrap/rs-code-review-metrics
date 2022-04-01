import { detailRowBuilder } from './detailsBuilder';

export const chartElementClickInitializer = () => {
  const barCharts = ['time-to-second-review', 'time-to-merge', 'pull-request-size'];

  $.each(barCharts, function (i, item) {
    const chart = Chartkick.charts[item];

    if (chart) {
      const chartObject = chart.getChartObject();
      chartObject.options.onClick = detailClickHandler;
    }
  });
};

const detailClickHandler = (e, activeElements) => {
  if (activeElements.length === 0) return;

  const chartElement = activeElements[0];
  const chartParent = chartElement._chart;

  const selectedRange = chartParent.data.labels[chartElement._index];
  const chartId = e.target.parentNode.id;

  getDetailObjects(selectedRange, chartId);
}

const getDetailObjects = (selectedRange, chartId) => {
  const chartData = $('#modal-popup').data('urls')[chartId];
  const detailsUrl = chartData.url;
  const dataMetric = chartData.metric;

  jQuery.ajax({
    url: detailsUrl,
    type: 'get',
    dataType: 'json',
    success: function (data) {
      detailRowBuilder(data[selectedRange], dataMetric);

      $('#modal-title').html(`Current Range [ ${selectedRange} ${dataMetric} ]`);
      $('#modal-popup').modal('show');
    },
    error: function () {
      console.log('failure');
    }
  });
};
