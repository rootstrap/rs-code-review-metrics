module Builders
  module MetricChart
    module Blog
      class TechnologyVisitsGrowthMom < Builders::MetricChart::Blog::GrowthMonthOverMonth
        def metric_name
          Metric.names[:blog_visits]
        end
      end
    end
  end
end
