module Metrics
  module ReviewTurnaround
    class PerDepartment < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |department_id, metric_value|
            Metric.new(department_id, interval.first, metric_value)
          end
        end
      end

      def query(interval)
        Department.joins(languages: {
                           repositories: { review_requests: :completed_review_turnarounds }
                         })
                  .where(completed_review_turnarounds: { created_at: interval })
                  .where(id: @entity_id)
                  .group(:id)
                  .pluck(:id, Arel.sql('AVG(completed_review_turnarounds.value)'))
      end
    end
  end
end
