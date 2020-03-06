module Metrics
  ##
  # This MetricProcessor does nothing.
  class NullProcessor < MetricProcessor
    ##
    # Since this object is a Null processor it does not generate any processing.
    def process_events; end
  end
end
