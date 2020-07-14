module Builders
  module MetricChart
    module Blog
      class TechnologyBlogPostCount < Builders::MetricChart::Blog::Base
        def metric_name
          Metric.names[:blog_post_count]
        end
      end
    end
  end
end
