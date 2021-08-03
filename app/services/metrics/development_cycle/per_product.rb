module Metrics
  module DevelopmentCycle
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

        resolved_issues = product.jira_project.jira_issues.where(resolved_at: interval)
        return [] if resolved_issues.empty?

        total_development_cycle = development_cycle(resolved_issues)['average']

        avg_development_cycle = 0
        if total_development_cycle.positive?
          avg_development_cycle = total_development_cycle / resolved_issues.count
        end

        [[
          @entity_id, {
            development_cycle: avg_development_cycle
          }
        ]]
      end

      def development_cycle(resolved_issues)
        resolved_issues.each_with_object(Hash.new(0)) do |issue, result|
          result['average'] += (issue.resolved_at - issue.in_progress_at) / 1.day
        end
      end
    end
  end
end
