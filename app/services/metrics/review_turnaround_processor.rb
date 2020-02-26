module Metrics
  ##
  # Does the processing of the given events to generate the review_turnaround
  # metric.
  #
  # The review_turnaround value is defined as the number of seconds between
  #   - the instant when a PullRequestReview is created
  #
  #   up to
  #
  #   - the instant when a PullRequestReviewEvent for that same PullRequestReview
  #     is received.
  class ReviewTurnaroundProcessor < Metric
    private

    ##
    # Processes the given events to generate the review_turnaround metrics.
    def process_events
      @events.each do |event|
        process_event(event: event) if process_event?(event: event)
      end
    end

    def process_event?(event:)
      %w[pull_request review].include?(event.name)
    end

    ##
    # Process a single event.
    # If the event is not related to a turn around event it ignores it.
    def process_event(event:)
      update_metric(
        entity_key: event.project.name,
        metric_key: 'review_turnaround',
        value: review_turnaround_value(event: event),
        value_timestamp: nil
      )
    end

    ##
    # Returns the review turnaround value for the given event.
    def review_turnaround_value(event:)
      # Placeholder until the handling of the PullRequestReviewEvent
      3600
    end
  end
end
