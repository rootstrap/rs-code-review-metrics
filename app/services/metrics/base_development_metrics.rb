module Metrics
  class BaseDevelopmentMetrics < Metrics::Base
    def initialize(interval = nil)
      @interval = interval
    end

    def call
      process
    end
  end
end
