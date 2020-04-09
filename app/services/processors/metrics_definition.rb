module Processors
  class MetricsDefinition < BaseService
    def call
      process_all_metrics_definitions
    end

    private

    def metrics_definitions
      @metrics_definitions ||= ::MetricsDefinition.all
    end

    def process_all_metrics_definitions
      metrics_definitions.each do |metrics_definition|
        process_each(
          metrics_definition: metrics_definition
        )
      end
    end

    def process_each(metrics_definition:)
      MetricDefinitionTimeIntervals.call(metrics_definition: metrics_definition)
    end
  end
end
