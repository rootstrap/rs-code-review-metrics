module Metrics
  module MergeTime
    class PerDepartment < Metrics::BaseDevelopmentMetrics
      private

      def process
        metrics = []
        week_intervals = split_in_weeks(metric_interval)
        week_intervals.map do |week|
          interval = build_interval(week)
          project_metrics_per_department(interval).each do |department_id, metric_value|
            metrics << Metric.new(department_id,
                                  Department.name,
                                  interval.first,
                                  :merge_time,
                                  metric_value)
          end
        end
        metrics
      end

      def project_metrics_per_department(interval)
        Department.joins(languages: { projects: { pull_requests: :merge_time } })
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
