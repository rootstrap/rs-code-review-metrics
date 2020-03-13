module Metrics
  ##
  # This object collects the events of interest for a given set of MetricsDefinitions
  class MetricsDefinitionsEventsCollector < BaseService
    attr_reader :metrics_definitions, :up_to

    def initialize(metrics_definitions:, up_to:)
      @metrics_definitions = metrics_definitions
      @up_to = up_to
    end

    def call
      events_to_process_for_all
    end

    private

    ##
    # Returns an array with the events to process.
    # It polls the given metrics_definitions to know which events to query
    # to avoid querying more events than needed.
    def events_to_process_for_all
      Event.occurred_after(oldest_event_time_to_process)
           .occurred_up_to(up_to)
           .order(:occurred_at)
    end

    ##
    # Query all the metrics_definitions to get the oldest time of the events to
    # process
    def oldest_event_time_to_process
      metrics_definitions.minimum(:last_processed_event_time)
    end
  end
end
