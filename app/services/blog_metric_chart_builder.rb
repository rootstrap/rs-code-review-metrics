class BlogMetricChartBuilder
  def technology_visits
    build_chart_info_for(Metric.names[:blog_visits])
  end

  def technology_blog_post_count
    build_chart_info_for(Metric.names[:blog_post_count])
  end

  private

  def build_chart_info_for(metric_name)
    Technology.all.map do |technology|
      {
        name: technology.name.titlecase,
        data: metrics_data_for(technology, metric_name)
      }
    end
  end

  def metrics_data_for(technology, metric_name)
    metrics = technology.metrics
                        .where(name: metric_name)
                        .where('value_timestamp > ?', 1.year.ago)
                        .order(:value_timestamp)

    metrics.each.inject({}) do |hash, metric|
      hash.merge!(metric.value_timestamp.strftime('%B %Y') => metric.value)
    end
  end
end
