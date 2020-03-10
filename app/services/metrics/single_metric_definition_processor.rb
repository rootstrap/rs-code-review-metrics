module Metrics
  ##
  # Process the metrics of a single MetricsDefinition.
  class SingleMetricDefinitionProcessor < BaseService
    attr_reader :metrics_definition, :events

    def initialize(metrics_definition:, events:)
      @metrics_definition = metrics_definition
      @events = events
    end

    ##
    # Processes the metrics
    def call
      process
    end

    private

    ##
    # Returns the concrete MetricsProcessor to process the metrics definition.
    def metrics_processor
      metrics_definition.metrics_processor.constantize
    end

    ##
    # Makes the given metric to process all the events.
    def process
      events_starting_at = metrics_definition_process_events_after_time

      metrics_definition.time_period.each_from(events_starting_at, up_to: now) do |time_interval|
        metrics_processor.call(events: events, time_interval: time_interval)
        metrics_definition.update!(last_processed_event_time: events.last.created_at)
      end
    end

    ##
    # If the given metrics_definition had been processed before return the time
    # of the last event processed.
    # If the metrics_definition was never processed before return all the time
    # of the oldest event
    def metrics_definition_process_events_after_time
      metrics_definition.last_processed_event_time || Event.minimum(:created_at)
    end

    ##
    # Return the current time
    def now
      Time.zone.now
    end
  end
end
