module Builders
  module MetricChart
    module Blog
      class TechnologyVisits < Builders::MetricChart::Blog::Base
        def metric_name
          Metric.names[:blog_visits]
        end
      end
    end
  end
end
