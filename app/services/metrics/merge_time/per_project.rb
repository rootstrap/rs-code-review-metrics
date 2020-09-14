module Metrics
  module MergeTime
    class PerProject < Metrics::BaseDevelopmentMetrics
      private

      def process
        metrics_per_project.each do |project_id, merge_times_value|
          create_or_update_metric(project_id, Project.name, merge_time_interval,
                                  merge_times_value, :merge_time)
        end
      end

      def metrics_per_project
        Project.joins(pull_requests: :merge_time)
               .where(merge_times: { created_at: merge_time_interval })
               .group(:id)
               .pluck(:id, Arel.sql('AVG(merge_times.value)'))
      end

      def merge_time_interval
        @merge_time_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
