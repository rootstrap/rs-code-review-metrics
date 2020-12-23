module Metrics
  module ReviewTurnaround
    class PerUserProject < Metrics::BaseDevelopmentMetrics
      private

      def process
        metrics = []
        week_intervals = split_in_weeks(metric_interval)
        week_intervals.map do |week|
          interval = build_interval(week)
          filtered_review_turnarounds(interval).each do |project_id, owner_id, metric_value|
            entity = find_user_project(owner_id, project_id)
            metrics << Metric.new(entity.id,
                                  UsersProject.name,
                                  interval.first,
                                  :review_turnaround,
                                  metric_value)
          end
        end
        metrics
      end

      def filtered_review_turnarounds(interval)
        ::CompletedReviewTurnaround.joins(:review_request)
                                   .where(created_at: interval)
                                   .group(:project_id, :owner_id)
                                   .pluck(:project_id,
                                          :owner_id,
                                          Arel.sql('AVG(completed_review_turnarounds.value)'))
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
