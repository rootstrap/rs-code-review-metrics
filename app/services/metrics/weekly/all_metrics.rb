module Metrics
  module Weekly
    class AllMetrics < BaseService
      def call
        process
      end

      private

      def process
        Metric.today_daily_metrics.find_each do |daily_metric|
          create_or_update(daily_metric)
        end
      end

      def create_or_update(daily_metric)
        metric = Metric.find_or_initialize_by(
          ownable: daily_metric.ownable,
          value_timestamp: week_range,
          interval: :weekly,
          name: daily_metric.name
        )

        value = metric_avg(daily_metric)
        return metric.update!(value: value) if metric.persisted?

        metric.value = value
        metric.value_timestamp = current_time
        metric.save!
      end

      def metric_avg(daily_metric)
        Metric.where(
          value_timestamp: week_range,
          ownable: daily_metric.ownable,
          interval: :daily,
          name: daily_metric.name
        ).average(:value)
      end

      def week_range
        @week_range ||= current_time.beginning_of_week..current_time.end_of_week
      end

      def current_time
        @current_time = Time.zone.now
      end
    end
  end
end
