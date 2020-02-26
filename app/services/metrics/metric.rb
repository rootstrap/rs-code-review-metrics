module Metrics
  ##
  # Base class for classes that do the processing of a Metric from given events.
  class Metric < BaseService
    def initialize(events:)
      @events = events
    end

    ##
    # Processes the given events to generate the metrics.
    def call
      process_events
    end

    private

    ##
    # Creates or updates the value of the metric with the key (entity_key, metric_key).
    def update_metric(entity_key:, metric_key:, value:, value_timestamp:)
      find_or_create_metric(entity_key: entity_key, metric_key: metric_key) do |metric|
        metric.value = value
        metric.value_timestamp = value_timestamp
      end
    end

    def find_or_create_metric(entity_key:, metric_key:, &block)
      ::Metric.find_or_create_by!(entity_key: entity_key, metric_key: metric_key, &block)
    end
  end
end
