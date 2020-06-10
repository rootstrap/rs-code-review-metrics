module Processors
  class BlogPostCountMetricsPartialUpdater < BlogPostCountMetricsUpdater
    private

    def starting_time_to_update(technology)
      last_updated_timestamp = Metric.where(
        name: Metric.names[:blog_post_count],
        interval: Metric.intervals[:monthly],
        ownable: technology
      ).pluck(:value_timestamp).max

      last_updated_timestamp&.beginning_of_month || first_publication_time
    end
  end
end
