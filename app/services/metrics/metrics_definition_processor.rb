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
    def all_metrics_definitions
      MetricsDefinition.all
    end

    ##
    # Makes each metric defined to process all the events.
    def process_all_metrics_definitions
      metrics_definitions = all_metrics_definitions
      events = events_to_process_for_all(metrics_definitions)

      process(metrics_definitions: metrics_definitions, events: events)
    end

    ##
    # Makes each metric in the given metrics_definitions to process all the given
    # events.
    def process(metrics_definitions:, events:)
      return if events.empty?

      metrics_definitions.each do |metrics_definition|
        process_each(
          metrics_definition: metrics_definition,
          events: events
        )
      end
    end

    ##
    # Makes the given metric to process all the events.
    def process_each(metrics_definition:, events:)
      SingleMetricDefinitionProcessor.call(metrics_definition: metrics_definition,
                                           events: events)
    end

    ##
    # Returns an array with the events to process.
    # It polls the given metrics_definitions to know which events to query
    # to avoid querying more events than needed.
    def events_to_process_for_all(metrics_definitions)
      Event.received_after(oldest_event_time_to_process_all(metrics_definitions))
           .order(:occured_at)
    end

    ##
    # Query all the metrics_definitions to get the oldest time of the events to
    # process
    def oldest_event_time_to_process_all(metrics_definitions)
      metrics_definitions.minimum(:last_processed_event_time)
    end
  end
end
