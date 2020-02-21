##
# This job processes the Github events previously stored, generates the
# metrics and leaves them in a ready to use state.
class ProcessMetricsJob < ApplicationJob
  queue_as :default

  ##
  # Delegates the processing to the MetricsProcessor service.
  def perform
    Metrics::MetricsProcessor.call
  end
end
