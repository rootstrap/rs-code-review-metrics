module Metrics
  ##
  # This Metric does nothing.
  class NullProcessor < BaseMetricProcessor
    ##
    # Since this object is a Null processor it does not generate any processing.
    def process_events(events:, time_interval:); end
  end
end
