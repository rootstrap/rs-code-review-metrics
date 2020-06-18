module Builders
  module BlogMetricChart
    class GrowthMonthOverMonth < Builders::BlogMetricChart::Base
      def initialize(months = 13)
        super(months + 1)
      end

      private

      def process_data(metrics_data)
        metrics_data.each_with_object({}) do |(month, metric_value), hash|
          previous_metric_value = metrics_data[month.last_month]
          next(hash) if previous_metric_value.nil? || previous_metric_value.zero?

          hash[month] = growth_for(metric_value, previous_metric_value)
        end
      end

      def growth_for(metric_value, previous_metric_value)
        (metric_value - previous_metric_value) / previous_metric_value * 100
      end
    end
  end
end
