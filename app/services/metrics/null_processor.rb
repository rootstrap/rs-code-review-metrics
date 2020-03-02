module Metrics
  ##
  # This Metric does nothing.
  class NullProcessor < Metric
    ##
    # Processes the given events to generate the review_turnaround metrics.
    # Since this object is a Null processor it does not generate any processing.
    def process_events(events:, time_interval:); end
  end
end
