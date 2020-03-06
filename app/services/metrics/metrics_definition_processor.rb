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
    # Returns the concrete MetricsProcessor to process the metrics definition.
    def metrics_processor_for(metrics_definition)
      metrics_definition.metrics_processor.constantize
    end

    ##
    # Makes each metric defined to process all the events.
    def process_all_metrics
      metrics_definitions = all_metrics_definitions

      events = events_to_process_for(metrics_definitions)

      return if events.empty?

      metrics_definitions.each do |metrics_definition|
        metrics_processor = metrics_processor_for(metrics_definition)

        process(metrics_processor: metrics_processor,
                events: events,
                metrics_definition: metrics_definition)
      end
    end

    ##
    # Makes the given metric to process all the events.
    def process(metrics_processor:, events:, metrics_definition:)
      time_interval = metrics_definition.time_interval_starting_at(Time.zone.today)

      metrics_processor.call(events: events, time_interval: time_interval)

      metrics_definition.update!(last_processed_event_time: events.last.created_at)
    end

    ##
    # Returns an array with the events to process.
    # It polls the given metrics_definitions to know which events to query
    # to avoid querying more events than needed.
    def events_to_process_for(metrics_definitions)
      Event.received_after(minimum_time_among(metrics_definitions))
           .order(:created_at)
    end

    ##
    # Query all the metrics_definitions to get the minimum for the events to
    # process
    def minimum_time_among(metrics_definitions)
      metrics_definitions.minimum(:last_processed_event_time)
    end
  end
end
