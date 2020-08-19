module Metrics
  class TimeIntervalResolver < BaseService
    HOURS_RANGE = { '1-12': 12, '12-24': 24, '24-36': 36,
                    '36-48': 48, '48-60': 60, '60-72': 72 }.freeze

    def initialize(value)
      @value = value
    end

    def call
      return '72+' if @value >= 72

      HOURS_RANGE.each { |interval, hour| break interval.to_s if @value < hour }
    end
  end
end
