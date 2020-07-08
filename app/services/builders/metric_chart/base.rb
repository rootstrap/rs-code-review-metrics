module Builders
  module MetricChart
    class Base < BaseService
      def initialize(periods = 13)
        @periods = periods
      end

      def call
        datasets = entities.map do |entity|
          generate_results_for(
            entity_name: entity_name(entity),
            metrics: entity_metrics(entity),
            hidden: true
          )
        end

        totals = generate_results_for(
          entity_name: 'Totals',
          metrics: Metric.where(ownable_type: metric_ownable_type.to_s),
          hidden: false
        )

        MetricsDatasetGroup.new(datasets, totals)
      end

      private

      attr_reader :periods

      def generate_results_for(entity_name:, metrics:, hidden:)
        metrics_data = collect_data(metrics)
        processed_data = process_data(metrics_data)
        {
          name: entity_name,
          data: format_data(processed_data),
          dataset: { hidden: hidden }
        }
      end

      def collect_data(metrics)
        metrics.where(name: metric_name, interval: metric_interval)
               .group_by_period(grouping_period, :value_timestamp, last: periods)
               .sum(:value)
      end

      def process_data(metrics_data)
        metrics_data
      end

      def format_data(metrics_data)
        metrics_data.transform_keys { |date| date.strftime(chart_date_format) }
      end

      def entities
        raise NoMethodError
      end

      def entity_name(_entity)
        raise NoMethodError
      end

      def entity_metrics(_entity)
        raise NoMethodError
      end

      def metric_ownable_type
        raise NoMethodError
      end

      def metric_name
        raise NoMethodError
      end

      def metric_interval
        raise NoMethodError
      end

      def chart_date_format
        raise NoMethodError
      end

      def grouping_period
        raise NoMethodError
      end
    end
  end
end
