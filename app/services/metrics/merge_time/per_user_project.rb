module Metrics
  module MergeTime
    class PerUserProject < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |project_id, owner_id, metric_value|
            entity = find_user_project(owner_id, project_id)
            Metric.new(entity.id, interval.first, metric_value)
          end
        end
      end

      def query(interval)
        ::MergeTime.joins(:pull_request)
                   .where(events_pull_requests: { merged_at: interval, owner_id: @entity_id })
                   .group(:project_id, :owner_id)
                   .pluck(:project_id, :owner_id, Arel.sql('AVG(merge_times.value)'))
      end
    end
  end
end
