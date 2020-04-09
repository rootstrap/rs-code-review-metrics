module Metrics
  ##
  # This MetricProcessor does nothing.
  class NullProcessor < Processors::Metric
    ##
    # Since this object is a Null processor it does not generate any processing.
    def process; end
  end
end
