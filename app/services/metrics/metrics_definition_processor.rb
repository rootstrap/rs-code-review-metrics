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
    # Returns an array with the events to process.
    # It polls the given metrics_definitions to know which events to query
    # to avoid querying more events than needed.
    def events_to_process
      @events_to_process ||= MetricsDefinitionsEventsCollector.call(
        metrics_definitions: metrics_definitions,
        up_to: Time.zone.now
      )
    end

    ##
    # Makes each metric defined to process all the events.
    def process_all_metrics_definitions
      return if events_to_process.empty?

      metrics_definitions.each do |metrics_definition|
        process_each(
          metrics_definition: metrics_definition
        )
      end
    end

    ##
    # Makes the given metric to process all the events.
    def process_each(metrics_definition:)
      SingleMetricDefinitionProcessor.call(metrics_definition: metrics_definition,
                                           events: events_to_process)
    end
  end
end
