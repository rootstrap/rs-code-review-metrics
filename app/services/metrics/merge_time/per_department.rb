module Metrics
  module MergeTime
    class PerDepartment < Metrics::Base
      def initialize(interval = nil)
        @interval = interval
      end

      def call
        process
      end

      private

      def process
        project_metrics_per_department.each do |department_id, amount, metrics_value|
          turnaround = amount != 1 ? calculate_turnaround(metrics_value, amount) : metrics_value
          create_or_update_metric(department_id, Department.to_s, metric_interval,
                                  turnaround, :merge_time)
        end
      end

      def project_metrics_per_department
        Department.joins(projects: :metrics)
                  .where(metrics: { name: :merge_time })
                  .group(:id)
                  .pluck(:id, Arel.sql('COUNT(*), SUM(metrics.value)'))
      end

      def calculate_turnaround(metrics_value, amount)
        metrics_value / amount
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end