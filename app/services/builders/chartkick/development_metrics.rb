module Builders
  module Chartkick
    class DevelopmentMetrics < BaseService
      def initialize(entity_id, period)
        @entity_id = entity_id
        @period = period
      end

      def call
        build
      end

      private

      def build
        metric_names.each_with_object({}) do |metric_name, hash|
          hash[metric_name] = metric_data(metric_name)
        end
      end

      def metric_names
        entities_by_metric.keys
      end

      def metric_data(metric_name)
        Builders::Chartkick::MetricData.call(
          @entity_id,
          entities_by_metric[metric_name],
          metric_name,
          @period
        )
      end

      class Project < DevelopmentMetrics
        private

        def entities_by_metric
          {
            review_turnaround: %w[project users_project],
            merge_time: %w[project users_project project_distribution]
          }
        end
      end

      class Department < DevelopmentMetrics
        private

        def entities_by_metric
          {
            review_turnaround: %w[department language department_distribution],
            merge_time: %w[department language department_distribution],
            pull_request_size: %w[department_distribution]
          }
        end
      end
    end
  end
end
