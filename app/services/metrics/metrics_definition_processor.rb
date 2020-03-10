module Metrics
  ##
  # For each metric definition it does the processing of the Github events
  # previously stored and leaves the generated metrics in the Metrics table.
  class MetricsDefinitionProcessor < BaseService
    ##
    # Processes the metrics
    def call
      process_all_metrics
    end

    private

    ##
    # Returns all the defined metrics to process.
    def all_metrics_definitions
      MetricsDefinition.all
    end

    ##
    # Makes each metric defined to process all the events.
    def process_all_metrics
      metrics_definitions = all_metrics_definitions
      events = events_to_process_for_all(metrics_definitions)
      return if events.empty?

      metrics_definitions.each do |metrics_definition|
        process(
          events: events,
          metrics_definition: metrics_definition
        )
      end
    end

    ##
    # Returns the concrete MetricsProcessor to process the metrics definition.
    def metrics_processor_for(metrics_definition)
      metrics_definition.metrics_processor.constantize
    end

    ##
    # Makes the given metric to process all the events.
    def process(events:, metrics_definition:)
      events_starting_at = metrics_definition_process_events_after_time(metrics_definition)

      metrics_definition.time_period.each_from(events_starting_at, up_to: now) do |time_interval|
        metrics_processor = metrics_processor_for(metrics_definition)
        metrics_processor.call(events: events, time_interval: time_interval)
        metrics_definition.update!(last_processed_event_time: events.last.created_at)
      end
    end

    ##
    # Returns an array with the events to process.
    # It polls the given metrics_definitions to know which events to query
    # to avoid querying more events than needed.
    def events_to_process_for_all(metrics_definitions)
      Event.received_after(oldest_event_time_to_process_all(metrics_definitions))
           .order(:created_at)
    end

    ##
    # Query all the metrics_definitions to get the oldest time of the events to
    # process
    def oldest_event_time_to_process_all(metrics_definitions)
      metrics_definitions.minimum(:last_processed_event_time)
    end

    ##
    # If the given metrics_definition had been processed before return the time
    # of the last event processed.
    # If the metrics_definition was never processed before return
    def metrics_definition_process_events_after_time(metrics_definition)
      metrics_definition.last_processed_event_time || Event.minimum(:created_at)
    end

    ##
    # Return the current time
    def now
      Time.zone.now
    end
  end
end
