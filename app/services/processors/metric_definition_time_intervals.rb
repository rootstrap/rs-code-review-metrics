module Processors
  class MetricDefinitionTimeIntervals < BaseService
    attr_reader :metrics_definition

    def initialize(metrics_definition:)
      @metrics_definition = metrics_definition
    end

    def call
      process
    end

    private

    def metrics_processor
      metrics_definition.metrics_processor.constantize
    end

    def process
      events_starting_at = metrics_definition_process_events_after_time

      metrics_definition
        .time_period
        .each_from(events_starting_at, up_to: Time.zone.now) do |time_interval|
          process_time_interval(time_interval)
        end
    end

    def process_time_interval(time_interval)
      metrics_processor.call(metrics_definition: metrics_definition,
                             time_interval: time_interval)
    end

    def metrics_definition_process_events_after_time
      metrics_definition.last_processed_event_time || Event.minimum(:occurred_at)
    end
  end
end
