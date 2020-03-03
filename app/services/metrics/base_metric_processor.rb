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
    # Processes the given events to generate the review_turnaround metrics.
    def process_events(events:, time_interval:)
      accumulators = create_accumulators

      iterate_events(events: events, time_interval: time_interval, accumulators: accumulators)

      update_metrics(time_interval: time_interval, accumulators: accumulators)
    end

    ##
    # Processes all the given events that are included in the time interval
    def iterate_events(events:, time_interval:, accumulators:)
      events.each do |event|
        next if skip_event?(event: event,
                            time_interval: time_interval,
                            accumulators: accumulators)

        process_event(event: event, accumulators: accumulators)
      end
    end

    ##
    # Some MetricProcessor may need to keep track of values like averages, sums,
    # flags, arrays or complex calculations.
    # Instead of using instance variables the processor creates a hash of
    # variables
    #     {
    #       accumulator_variable: value,
    #       ...
    #     }
    # that is passed along to the :process_event method.
    # The use of this accumulator allows to perform the calculation of many
    # metrics in a single iteration of all the events of a given time interval.
    # For example to calculate the review_turnaround for all the projects in a
    # single iteration of the events instead of one interation for each project.
    def create_accumulators
      {}
    end

    ##
    # MetricsProcessors are interested only in a some Events.
    # If this method returns true the event is ignored.
    #   event:, time_interval:
    def skip_event?(*)
      false
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
      ::Metric.find_or_create_by!(entity_key: entity_key, metric_key: metric_key, &block)
    end
  end
end
