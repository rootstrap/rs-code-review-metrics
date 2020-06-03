module Processors
  class BlogTechnologyViewsPartialUpdater < BlogTechnologyViewsUpdater
    private

    def metrics_by_timestamp
      Metric.where('value_timestamp >= ?', latest_technology_metrics_updated_at)
    end
  end
end
