module Metrics
  module PlannedToDone
    class PerProduct < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |product, metric_value|
            Metric.new(product, interval.first, metric_value)
          end
        end
      end

      def query(interval)
        product = Product.find(@entity_id)
        completed_sprints = product.jira_board.jira_sprints
                                   .where(started_at: interval, active: false)
        return [] if completed_sprints.empty?

        total_planned_to_done = planned_to_done_rate(completed_sprints)['rate']
        [[
          @entity_id, {
            planned_to_done_rate: total_planned_to_done
          }
        ]]
      end

      def planned_to_done_rate(completed_sprints)
        completed_sprints.each_with_object(Hash.new(0)) do |sprint, result|
          result['rate'] += sprint.points_completed / sprint.points_committed
        end
      end
    end
  end
end
