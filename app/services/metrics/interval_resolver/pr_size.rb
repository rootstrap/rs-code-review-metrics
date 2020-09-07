module Metrics
  module IntervalResolver
    class PrSize < Metrics::IntervalResolver::Base
      def ranges
        { '1-99': 100, '100-199': 200, '200-299': 300, '300-399': 400, '400-499': 500,
          '500-599': 600, '600-699': 700, '700-799': 800, '800-899': 900, '900-999': 1000 }
      end
    end
  end
end
