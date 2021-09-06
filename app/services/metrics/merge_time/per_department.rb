module Metrics
  module MergeTime
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
        Department.joins(languages: { projects: { pull_requests: :merge_time } })
                  .where(events_pull_requests: { merged_at: interval })
                  .where(id: @entity_id)
                  .group(:id)
                  .pluck(:id, Arel.sql('AVG(merge_times.value)'))
      end
    end
  end
end
