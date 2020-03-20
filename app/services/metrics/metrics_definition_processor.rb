module Metrics
  ##
  # For each metric definition it does the processing of the Github events
  # previously stored and leaves the generated metrics in the Metrics table.
  class MetricsDefinitionProcessor < BaseService
    ##
    # Processes the metrics
    def call
      process_all_metrics_definitions
    end

    private

    ##
    # Returns all the defined metrics to process.
    def metrics_definitions
      @metrics_definitions ||= MetricsDefinition.all
    end

    ##
    # Makes each metric defined to process all the events.
    def process_all_metrics_definitions
      metrics_definitions.each do |metrics_definition|
        process_each(
          metrics_definition: metrics_definition
        )
      end
    end

    ##
    # Makes the given metric to process all the events.
    def process_each(metrics_definition:)
      MetricDefinitionTimeIntervalsProcessor.call(metrics_definition: metrics_definition)
    end
  end
end
