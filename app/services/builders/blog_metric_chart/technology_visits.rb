module Builders
  module BlogMetricChart
    class TechnologyVisits < Builders::BlogMetricChart::Base
      def metric_name
        Metric.names[:blog_visits]
      end
    end
  end
end
