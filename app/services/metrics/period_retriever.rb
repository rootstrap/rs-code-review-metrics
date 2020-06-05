module Metrics
  class PeriodRetriever < BaseService
    INTERVALS = %w[daily weekly].freeze

    def initialize(period)
      @period = period
    end

    def call
      raise Graph::RangeDateNotSupported unless INTERVALS.include?(@period)

      Metrics::Group.const_get(@period.capitalize)
    end
  end
end
