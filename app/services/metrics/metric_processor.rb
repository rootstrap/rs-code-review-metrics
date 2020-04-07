module Metrics
  ##
  # Base class for classes that do the processing of a Metric.
  class MetricProcessor < BaseService
    attr_reader :metrics_definition, :time_interval

    def initialize(metrics_definition:, time_interval:)
      @metrics_definition = metrics_definition
      @time_interval = time_interval
    end

    ##
    # Processes the given events to generate the metrics.
    def call
      process
    end

    private

    ##
    # Sets the value of the metric with the key (entity_key, entity_type).
    def update_metric(entity:, value:, value_timestamp:)
      find_or_create_metric(entity: entity)
        .update!(value: value, value_timestamp: value_timestamp)
    end

    ##
    # Returns the Metric with the given (metrics_definition, entity_key, entity_type).
    # If the Metric does not exist it creates it.
    def find_or_create_metric(entity:)
      ::Metric.find_or_create_by!(ownable: entity,
                                  metrics_definition: metrics_definition)
    end
  end
end
