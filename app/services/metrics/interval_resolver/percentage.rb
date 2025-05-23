module Metrics
  module IntervalResolver
    class Percentage < Metrics::IntervalResolver::Base
      def ranges
        { '0-10': 10, '10-20': 20, '20-40': 40, '40-60': 60, '60-80': 80 }
      end
    end
  end
end
