module Queries
  class PeriodMetricRetriever < BaseService
    INTERVALS = %w[daily weekly].freeze

    def initialize(period)
      @period = period
    end

    def call
      raise Graph::RangeDateNotSupported unless INTERVALS.include?(@period)

      Queries.const_get("#{@period.capitalize}Metrics")
    end
  end
end
