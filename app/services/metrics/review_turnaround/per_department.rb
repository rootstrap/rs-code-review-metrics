module Metrics
  module ReviewTurnaround
    class PerDepartment < Metrics::BaseDevelopmentMetrics
      private

      def process
        project_metrics_per_department.each do |department_id, amount, metrics_value|
          turnaround = calculate_average(metrics_value, amount)
          create_or_update_metric(department_id, Department.name, metric_interval,
                                  turnaround, :review_turnaround)
        end
      end

      def project_metrics_per_department
        Department.joins(languages: { projects: :metrics })
                  .where(metrics: { name: :review_turnaround, created_at: metric_interval })
                  .group(:id)
                  .pluck(:id, Arel.sql('COUNT(*), SUM(metrics.value)'))
      end

      def calculate_average(metrics_value, amount)
        metrics_value / amount
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
