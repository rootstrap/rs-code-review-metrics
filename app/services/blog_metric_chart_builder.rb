class BlogMetricChartBuilder
  def technology_visits
    Technology.all.map do |technology|
      {
        name: technology.name.titlecase,
        data: metrics_data_for(technology)
      }
    end
  end

  private

  def metrics_data_for(technology)
    technology.metrics.order(:value_timestamp).each.inject({}) do |hash, metric|
      hash.merge!(metric.value_timestamp.strftime('%B') => metric.value)
    end
  end
end
