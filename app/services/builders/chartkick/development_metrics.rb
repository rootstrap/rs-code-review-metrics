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

      def metric_class
        Metrics::Group::Weekly
      end

      class Project < DevelopmentMetrics
        private

        def metric_data(metric_name)
          {
            per_project: metric_class.call(
                entity_name: 'project',
                entity_id: @entity_id,
                metric_name: metric_name,
                prev: @period
              ),
            per_users_project: metric_class.call(
              entity_name: 'users_project',
              entity_id: @entity_id,
              metric_name: metric_name,
              prev: @period
            )
          }
        end
      end

      class Department < DevelopmentMetrics
        private

        def metric_data(metric_name)
          {
            per_department: metric_class.call(
              entity_name: 'department',
              entity_id: @entity_id,
              metric_name: metric_name,
              prev: @period
            ),
            per_language: metric_class.call(
              entity_name: 'language',
              entity_id: @entity_id,
              metric_name: metric_name,
              prev: @period
            )
          }
        end
      end
    end
  end
end
