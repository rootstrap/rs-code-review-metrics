module Metrics
  ##
  # Base class for classes that do the processing of a Metric from a
  # collection of events.
  class MetricProcessor < BaseService
    attr_reader :metrics_definition, :events, :time_interval

    def initialize(metrics_definition:, events:, time_interval:)
      @metrics_definition = metrics_definition
      @events = events
      @time_interval = time_interval

      initialize_accumulators
    end

    ##
    # Processes the given events to generate the metrics.
    # The given @events are expected to include all the events during the full
    # time interval ( [@starting_at, @starting_at + @time_span) ).
    def call
      process_events
    end

    private

    def initialize_accumulators; end

    ##
    # Processes the given events to generate the metrics.
    def process_events
      iterate_events
      update_metrics
    end

    ##
    # Processes all the given events that are included in the time interval
    def iterate_events
      events.each do |event|
        next if skip_event?(event: event)

        process_event(event: event)
      end
    end

    def skip_event?(event:)
      !process_event?(event: event)
    end

    ##
    # MetricsProcessors are interested only in a some Events.
    # If this method returns true the event is processed, otherwise it is ignored.
    #     process_event?(event:)
    def process_event?(*)
      true
    end

    ##
    # Sets the the value of the metric with the key (entity_key, metric_key).
    def update_metric(entity_key:, metric_key:, value:, value_timestamp:)
      find_or_create_metric(entity_key: entity_key, metric_key: metric_key)
        .update!(value: value, value_timestamp: value_timestamp)
    end

    ##
    # Returns the Metric with the given (entity_key:, metric_key:) and evaluates
    # the &block on it.
    # If the Metric does not exist it creates it.
    def find_or_create_metric(entity_key:, metric_key:, &block)
      ::Metric.find_or_create_by!(metrics_definition: metrics_definition,
                                  entity_key: entity_key,
                                  metric_key: metric_key, &block)
    end
  end
end
