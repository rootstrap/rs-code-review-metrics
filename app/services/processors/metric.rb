module Processors
  class Metric < BaseService
    attr_reader :metrics_definition, :time_interval

    def initialize(metrics_definition:, time_interval:)
      @metrics_definition = metrics_definition
      @time_interval = time_interval
    end

    def call
      process
    end

    private

    def update_metric(entity:, value:, value_timestamp:)
      find_or_create_metric(entity: entity)
        .update!(value: value, value_timestamp: value_timestamp)
    end

    def find_or_create_metric(entity:)
      ::Metric.find_or_create_by!(ownable: entity,
                                  metrics_definition: metrics_definition)
    end
  end
end
