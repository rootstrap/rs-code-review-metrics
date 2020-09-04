module Metrics
  class IntervalResolver < BaseService
    def initialize(value)
      @value = value
    end

    def call
      matching_interval || upper_interval
    end

    private

    def matching_interval
      ranges.find { |_interval, upper_limit| @value < upper_limit }&.first&.to_s
    end

    def upper_interval
      "#{ranges.values.max}+"
    end

    class Time < IntervalResolver
      def ranges
        { '1-12': 12, '12-24': 24, '24-36': 36, '36-48': 48, '48-60': 60, '60-72': 72 }
      end
    end

    class PRSize < IntervalResolver
      def ranges
        { '1-99': 100, '100-199': 200, '200-299': 300, '300-399': 400, '400-499': 500,
          '500-599': 600, '600-699': 700, '700-799': 800, '800-899': 900, '900-999': 1000 }
      end
    end
  end
end
