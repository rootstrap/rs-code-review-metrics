module Metrics
  module Weekly
    module ReviewTurnaround
      class PerUserProject < BaseService
        def call
          process
        end

        private

        def process
          daily_metrics.find_each do |daily_metric|
            create_or_update_metric(daily_metric.ownable)
          end
        end

        def current_time
          @current_time ||= Time.zone.now
        end

        def metric_average_during_week(user_project)
          Metric.where(
            value_timestamp: current_time.beginning_of_week..current_time.end_of_week,
            ownable_type: user_project.class.to_s,
            ownable_id: user_project.id,
            interval: :daily,
            name: :review_turnaround
          ).average(:value)
        end

        def daily_metrics
          Metric.where(value_timestamp: current_time.all_day,
                       interval: :daily, name: :review_turnaround)
        end

        def create_or_update_metric(user_project)
          value = metric_average_during_week(user_project)
          metric = Metric.find_or_initialize_by(
            interval: :weekly,
            name: :review_turnaround,
            value_timestamp: current_time.beginning_of_week..current_time.end_of_week,
            ownable_type: user_project.class.to_s,
            ownable_id: user_project.id
          )
          return metric.update!(value: value) if metric.persisted?

          metric.value = value
          metric.save!
        end
      end
    end
  end
end
