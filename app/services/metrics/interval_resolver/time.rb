module Metrics
  module IntervalResolver
    class Time < Metrics::IntervalResolver::Base
      def ranges
        { '1-12': 12, '12-24': 24, '24-36': 36, '36-48': 48, '48-60': 60, '60-72': 72 }
      end
    end
  end
end
