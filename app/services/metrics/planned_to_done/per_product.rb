module Metrics
  module PlannedToDone
    class PerProduct < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |product, sprint_values|
            binding.pry
            Metric.new(product, interval.first, sprint_values)
          end
        end
      end

      def query(interval)
        completed_sprints(interval)
        return [] if @completed_sprints.empty?

        planned_to_done_rate = (total_planned_to_done['rate'] * 100) / @completed_sprints.count
        planned_to_done_values = by_sprint_planned_to_done
        binding.pry
        [[
          @entity_id, {
            planned_to_done_rate: planned_to_done_rate,
            planned_to_done_values: by_sprint_planned_to_done

          }
        ]]
      end

      def product
        Product.find(@entity_id)
      end

      def completed_sprints(interval)
        @completed_sprints = product.jira_board.jira_sprints
                                    .where(started_at: interval, active: false)
      end

      def total_planned_to_done
        @completed_sprints.each_with_object(Hash.new(0)) do |sprint, result|
          result['rate'] += (sprint.points_completed / sprint.points_committed.to_f).round(2)
        end
      end

      def by_sprint_planned_to_done
        @completed_sprints.each_with_object({}) do |sprint, result|
          result[:sprint] = sprint.name
          result[:completed] = sprint.points_completed
          result[:committed] = sprint.points_committed
        end
      end
    end
  end
end
