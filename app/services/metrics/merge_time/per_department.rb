module Metrics
  module ReviewTurnaround
    class PerDepartment < Metrics::Base
      def initialize(interval = nil)
        @interval = interval
      end

      def call
        process
      end

      private

      def process
        department_metrics_values.each do |department_name, metrics_values|
          department_id = Department.find_by!(name: department_name)
          turnaround = calculate_turnaround(metrics_values)
          create_or_update_metric(department_id, Department.to_s, metric_interval,
                                  turnaround, :review_turnaround)
        end
      end

      def department_metrics_values
        Department.names.keys.each_with_object({}) do |department_name, hash|
          hash[department_name] = Metric.joins(project: :department)
                                         .where(departments: { name: department_name })
                                         .where(name: :merge_time)
                                         .pluck(:value)
          hash
        end
      end

      def calculate_turnaround(metrics_values)
        metrics_values.sum / metrics_values.size
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
