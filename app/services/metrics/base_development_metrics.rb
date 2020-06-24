module Metrics
  class BaseDevelopmentMetrics < Metrics::Base
    def initialize(interval = nil)
      @interval = interval
    end
  end
end
