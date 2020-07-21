module Builders
  module Chartkick
    class DevelopmentMetrics < BaseService
      METRIC_NAMES = %i[review_turnaround merge_time].freeze

      def initialize(entity_id, period)
        @entity_id = entity_id
        @period = period
      end

      def call
        build
      end

      private

      def build
        METRIC_NAMES.each_with_object({}) do |metric_name, hash|
          hash[metric_name] = metric_data(metric_name)
        end
      end

      class Project < DevelopmentMetrics
        private

        def metric_data(metric_name)
          Builders::Chartkick::MetricData.call(
            @entity_id,
            %w[project users_project project_distribution],
            metric_name,
            @period
          )
        end
      end

      class Department < DevelopmentMetrics
        private

        def metric_data(metric_name)
          Builders::Chartkick::MetricData.call(
            @entity_id,
            %w[department language department_distribution],
            metric_name,
            @period
          )
        end
      end
    end
  end
end
