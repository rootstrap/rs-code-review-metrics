module Builders
  module BlogMetricChart
    class Base < BaseService
      def initialize(months = 13)
        @months = months
      end

      def call
        metrics_result = Technology.all.map do |technology|
          generate_results_for(
            entity_name: technology.name.titlecase,
            metrics: technology.metrics
          )
        end

        metrics_result << generate_results_for(
          entity_name: 'Totals',
          metrics: Metric.where(ownable_type: Technology.to_s)
        )
      end

      private

      attr_reader :months

      def generate_results_for(entity_name:, metrics:)
        metrics_data = collect_data(metrics)
        processed_data = process_data(metrics_data)
        {
          name: entity_name,
          data: format_data(processed_data)
        }
      end

      def collect_data(technology_metrics)
        technology_metrics.where(name: metric_name)
                          .group_by_month(:value_timestamp, last: months)
                          .sum(:value)
      end

      def process_data(metrics_data)
        metrics_data
      end

      def format_data(metrics_data)
        metrics_data.transform_keys { |date| date.strftime('%B %Y') }
      end
    end
  end
end
