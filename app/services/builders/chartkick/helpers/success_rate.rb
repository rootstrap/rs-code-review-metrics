module Builders
  module Chartkick
    module Helpers
      class SuccessRate < BaseService
        attr_reader :entity_name, :metric_name, :intervals

        RateDetails = Struct.new(:rate, :successful, :total, :metric_detail)
        MetricSetting = Struct.new(:name, :value)

        def initialize(entity_name, metric_name, intervals)
          @entity_name = entity_name
          @metric_name = metric_name.to_s
          @intervals = intervals
        end

        def call
          return if total.zero?

          RateDetails.new(rate, successful, total, metric_detail)
        end

        private

        def metric_detail
          MetricSetting.new(metric_key, metric_setting)
        end

        def total
          @total ||= intervals.map { |interval| interval[1] }.sum
        end

        def successful
          @successful ||= intervals
                          .select { |tuple| time_interval_range.include?(tuple[0]) }
                          .sum { |_range, value| value }
        end

        def time_interval_range
          intervals.map { |tuple| tuple[0] }
                   .reject { |range| range.include?('+') }
                   .select { |range| range.split('-')[1].to_i <= metric_setting }
        end

        def metric_setting
          @metric_setting ||= SettingsService.success_rate(entity_name, metric_name)
        end

        def metric_key
          @metric_key ||= Setting::SUCCESS_PREFIX + '_' + entity_name + '_' + metric_name
        end

        def rate
          @rate ||= (successful * 100) / total
        end
      end
    end
  end
end
