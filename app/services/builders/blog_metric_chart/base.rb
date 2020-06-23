module Builders
  module BlogMetricChart
    class Base < BaseService
      def initialize(months = 13)
        @months = months
      end

      def call
        datasets = Technology.all.map do |technology|
          generate_results_for(
            entity_name: technology.name.titlecase,
            metrics: technology.metrics,
            hidden: true
          )
        end

        totals = generate_results_for(
          entity_name: 'Totals',
          metrics: Metric.where(ownable_type: Technology.to_s),
          hidden: false
        )

        BlogMetricsDatasetGroup.new(datasets, totals)
      end

      private

      attr_reader :months

      def generate_results_for(entity_name:, metrics:, hidden:)
        metrics_data = collect_data(metrics)
        processed_data = process_data(metrics_data)
        {
          name: entity_name,
          data: format_data(processed_data),
          dataset: { hidden: hidden }
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
