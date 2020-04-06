module Metrics
  ##
  # Process each time intervals of a single MetricsDefinition.
  class MetricDefinitionTimeIntervalsProcessor < BaseService
    attr_reader :metrics_definition

    def initialize(metrics_definition:)
      @metrics_definition = metrics_definition
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
    # Makes the given metric to process all its events.
    def process
      events_starting_at = metrics_definition_process_events_after_time

      metrics_definition.time_period.each_from(events_starting_at,
                                               up_to: Time.zone.now) do |time_interval|
        process_time_interval(time_interval)
      end
    end

    ##
    # Process the metrics for the given time_interval
    def process_time_interval(time_interval)
      metrics_processor.call(metrics_definition: metrics_definition,
                             time_interval: time_interval)
    end

    ##
    # If the given metrics_definition had been processed before return the time
    # of the last event processed.
    # If the metrics_definition was never processed before return the time
    # of the oldest event to process all existing events
    def metrics_definition_process_events_after_time
      metrics_definition.last_processed_event_time || Event.minimum(:occurred_at)
    end
  end
end
