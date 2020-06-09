module Processors
  class BlogTechnologyViewsPartialUpdater < BlogTechnologyViewsUpdater
    private

    def metrics_by_timestamp
      Metric.where('value_timestamp >= ?', latest_technology_metrics_updated_at)
    end

    def latest_technology_metrics_updated_at
      latest_visits_metrics_by_technology =
        Metric.where(name: Metric.names[:blog_visits], ownable_type: Technology.to_s)
              .group(:ownable_id)
              .maximum(:value_timestamp)

      latest_visits_metrics_by_technology.values.min || Time.zone.at(0)
    end
  end
end
