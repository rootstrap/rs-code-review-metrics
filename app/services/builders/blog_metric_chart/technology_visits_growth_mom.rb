module Builders
  module BlogMetricChart
    class TechnologyVisitsGrowthMom < Builders::BlogMetricChart::GrowthMonthOverMonth
      def metric_name
        Metric.names[:blog_visits]
      end
    end
  end
end
