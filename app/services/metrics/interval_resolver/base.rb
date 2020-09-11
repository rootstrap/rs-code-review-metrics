module Metrics
  module IntervalResolver
    class Base < BaseService
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
    end
  end
end
