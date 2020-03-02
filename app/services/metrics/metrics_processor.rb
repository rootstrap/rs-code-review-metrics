module Metrics
  ##
  # Does the processing of the Github events previously stored and leaves them
  # generated metrics in the metrics table.
  #
  # It takes care of processing only the metrics that are pending to be
  # processed.
  #
  # Currently the metrics are define hardcoded in this same class.
  class MetricsProcessor < BaseService
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
      events = events_to_process

      return if events.empty?

      last_event_time = events.last.created_at

      all_metrics_definitions.each do |metrics_definition|
        metric = metrics_processor_for(metrics_definition)

        process(metric: metric, events: events)

        metrics_definition.update!(last_processed_event_time: last_event_time)
      end
    end

    ##
    # Makes the given metric to process all the events.
    def process(metric:, events:)
      time_interval = TimeInterval.new(starting_at: Time.zone.today, duration: 1.day)

      metric.call(events: events, time_interval: time_interval)
    end

    ##
    # Returns an array with the events to process.
    # Currently it returns all the events but its final implementation will return
    # only the events that had not been processed yet.
    def events_to_process
      Event.all
    end
  end
end
