module Builders
  module Chartkick
    class DevelopmentMetrics < BaseService
      METRIC_NAMES = %i[review_turnaround merge_time].freeze

      def initialize(entity_id, period_metric_query)
        @entity_id = entity_id
        @period_metric_query = period_metric_query
      end

      def call
        build
      end

      private

      def build
        METRIC_NAMES.each_with_object({}) do |metric_name, hash|
          hash[metric_name] = {
            per_users_project: @period_metric_query.call(
              entity_name: 'users_project', entity_id: @entity_id, metric_name: metric_name
            ),
            per_project: @period_metric_query.call(
              entity_name: 'project', entity_id: @entity_id, metric_name: metric_name
            )
          }
          hash
        end
      end
    end
  end
end
