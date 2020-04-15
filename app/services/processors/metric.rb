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

    def find_or_create_metric(entity:, interval:, name:)
      ::Metric.find_or_create_by!(ownable: entity,
                                  metrics_definition: metrics_definition,
                                  interval: interval,
                                  name: name)
    end
  end
end
