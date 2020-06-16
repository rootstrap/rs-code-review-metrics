module Builders
  module BlogMetricChart
    class GrowthMonthOverMonth < Builders::BlogMetricChart::Base
      def initialize(months = 13)
        super(months + 1)
      end

      private

      def process_data(metrics_data)
        metrics_data.each.inject({}) do |hash, key_value_pair|
          month, metric_value = key_value_pair
          previous_metric_value = metrics_data[month.last_month]
          next(hash) if previous_metric_value.nil? || previous_metric_value.zero?

          hash.merge!(
            month => growth_for(metric_value, previous_metric_value)
          )
        end
      end

      def growth_for(metric_value, previous_metric_value)
        (metric_value - previous_metric_value) / previous_metric_value * 100
      end
    end
  end
end
