module Builders
  module BlogMetricChart
    class TechnologyBlogPostCount < Builders::BlogMetricChart::Base
      def metric_name
        Metric.names[:blog_post_count]
      end
    end
  end
end
