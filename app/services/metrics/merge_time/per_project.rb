module Metrics
  module MergeTime
    class PerProject < Metrics::BaseDevelopmentMetrics
      private

      def process
        metrics = []
        week_intervals = split_in_weeks(metric_interval)
        week_intervals.map do |week|
          interval = build_interval(week)
          metrics_per_project(interval).each do |project_id, metric_value|
            metrics << Metric.new(project_id,
                                  Project.name,
                                  interval.first,
                                  :merge_time,
                                  metric_value)
          end
        end
        metrics
      end

      def metrics_per_project(interval)
        Project.joins(pull_requests: :merge_time)
               .where(pull_requests: { merged_at: interval })
               .group(:id)
               .pluck(:id, Arel.sql('AVG(merge_times.value)'))
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
