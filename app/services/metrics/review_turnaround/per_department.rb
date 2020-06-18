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
        department_metrics_values.each do |department_id, metrics_values|
          turnaround = calculate_turnaround(metrics_values)
          create_or_update_metric(department_id, Department.to_s, metric_interval,
                                  turnaround, :review_turnaround)
        end
      end

      def department_metrics_values
        Metric.joins(project: :department)
              .where(name: :review_turnaround)
              .pluck('departments.id', :value)
              .each_with_object({}) do |(id, value), hash|
                (hash[id] ||= []) << value
                hash
              end
      end

      def calculate_turnaround(metrics_values)
        metrics_values_size = metrics_values.size
        return metrics_values.first if metrics_values_size == 1

        metrics_values.sum / metrics_values_size
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
