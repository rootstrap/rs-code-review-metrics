##
# This job processes the Github events previously stored, generates the
# metrics and leaves them in a ready to use state.
class ProcessMetricsJob < ApplicationJob
  queue_as :default

  ##
  # Delegates the processing to the MetricsDefinitionProcessor service.
  def perform
    Metrics::MetricsDefinitionProcessor.call
  end
end
