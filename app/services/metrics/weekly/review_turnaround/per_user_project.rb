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
            weekly_metric = weekly_of(daily_metric.ownable)
            if weekly_metric.present?
              next weekly_metric.update!(
                value: (daily_metric.value + weekly_metric.value) / current_time.wday
              )
            end

            create_weekly(daily_metric)
          end
        end

        def create_weekly(metric)
          Metric.create!(
            value: metric.value,
            interval: :weekly,
            name: :review_turnaround,
            ownable: metric.ownable,
            value_timestamp: current_time
          )
        end

        def current_time
          @current_time ||= Time.zone.now
        end

        def daily_metrics
          @daily_metrics ||= Metric.where(value_timestamp: current_time.all_day, interval: :daily)
        end

        def weekly_of(user)
          Metric.find_by(
            interval: :weekly,
            value_timestamp: current_time.beginning_of_week..current_time.end_of_week,
            ownable: user
          )
        end
      end
    end
  end
end
