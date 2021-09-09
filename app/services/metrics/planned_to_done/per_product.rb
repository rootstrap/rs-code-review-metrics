module Metrics
  module PlannedToDone
    class PerProduct < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |product, sprint_values|
            Metric.new(product, interval.first, sprint_values)
          end
        end
      end

      def query(interval)
        completed_sprints(interval)
        return [] if @completed_sprints.empty?

        [[
          @entity_id, {
            planned_to_done_values: @completed_sprints
          }
        ]]
      end

      def product
        Product.find(@entity_id)
      end

      def completed_sprints(interval)
        @completed_sprints = product.jira_board.jira_sprints
                                    .where(started_at: interval, active: false)
                                    .pluck(:name, :points_committed, :points_completed)
                                    .map do |name, points_committed, points_completed|
                                      {
                                        sprint: name,
                                        committed: points_committed,
                                        completed: points_completed
                                      }
                                    end
      end
    end
  end
end
