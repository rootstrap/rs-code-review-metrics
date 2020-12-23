module Metrics
  module ReviewTurnaround
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
                                  :review_turnaround,
                                  metric_value)
          end
        end
        metrics
      end

      def metrics_per_project(interval)
        Project.joins(review_requests: :completed_review_turnarounds)
               .where(completed_review_turnarounds: { created_at: interval })
               .group(:id)
               .pluck(:id, Arel.sql('AVG(completed_review_turnarounds.value)'))
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
