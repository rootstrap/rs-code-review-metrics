module Metrics
  ##
  # Base class for classes that do the processing of a Metric from a
  # collection of events.
  class BaseMetricProcessor < BaseService
    def initialize(events:, time_interval:)
      @events = events
      @time_interval = time_interval
    end

    ##
    # Processes the given events to generate the metrics.
    # The given @events are expected to include all the events during the full
    # time interval ( [@starting_at, @starting_at + @time_span) ).
    def call
      process_events(events: @events, time_interval: @time_interval)
    end

    private

    ##
    # Creates or updates the value of the metric with the key (entity_key, metric_key).
    def update_metric(entity_key:, metric_key:, value:, value_timestamp:)
      find_or_create_metric(entity_key: entity_key, metric_key: metric_key)
        .update!(value: value, value_timestamp: value_timestamp)
    end

    def find_or_create_metric(entity_key:, metric_key:, &block)
      ::Metric.find_or_create_by!(entity_key: entity_key, metric_key: metric_key, &block)
    end
  end
end
