module Builders
  module Chartkick
    class DevelopmentMetrics < BaseService
      def initialize(entity_id, from, to)
        @entity_id = entity_id
        @from = from&.to_datetime&.beginning_of_day
        @to = to&.to_datetime&.end_of_day
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
          @from,
          @to
        )
      end

      class Product < DevelopmentMetrics
        private

        def entities_by_metric
          metrics = {}

          if product_has_jira_board_associated?(@entity_id)
            metrics.merge!(defect_escape_rate_entities,
                           development_cycle_entities,
                           planned_to_done_entities)
          end
          metrics
        end

        def defect_escape_rate_entities
          { defect_escape_rate: %w[defect_escape_rate defect_escape_values] }
        end

        def development_cycle_entities
          { development_cycle: %w[development_cycle_average development_cycle_values] }
        end

        def planned_to_done_entities
          { planned_to_done: %w[planned_to_done_average planned_to_done_values] }
        end

        def product_has_jira_board_associated?(product_id)
          ::Product.find(product_id).jira_board&.present?
        end
      end

      class Repository < DevelopmentMetrics
        private

        def entities_by_metric
          metrics = {
            review_turnaround: %w[repository users_repository repository_distribution],
            merge_time: %w[repository users_repository repository_distribution],
            pull_request_size: %w[repository_distribution],
            review_coverage: %w[repository repository_distribution]
          }
          metrics
        end

        def defect_escape_rate_entities
          { defect_escape_rate: %w[defect_escape_rate defect_escape_values] }
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
