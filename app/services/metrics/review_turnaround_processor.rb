module Metrics
  ##
  # Does the processing of the given events to generate the review_turnaround
  # metric.
  #
  # The review_turnaround value is defined as the number of seconds between
  #   - the instant when a PullRequest review_requested action is created
  #     (https://developer.github.com/v3/activity/events/types/#pullrequestevent)
  #
  #   up to
  #
  #   - the instant when a PullRequestReviewEvent for that same PullRequestReview
  #     is 'submitted', 'edited' or 'dismissed'.
  #     (https://developer.github.com/v3/activity/events/types/#pullrequestreviewevent)
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
      event.name == 'review'
    end

    ##
    # Process a single event.
    # If the event is not related to a turn around event it ignores it.
    def process_event(event:)
      update_metric(
        entity_key: event.project.name,
        metric_key: 'review_turnaround',
        value: review_turnaround_as_seconds(event: event),
        value_timestamp: nil
      )
    end

    ##
    # Returns the review turnaround value for the given event.
    def review_turnaround_as_seconds(event:)
      # RFC should we move these times to the Event model?
      review_attended_at = Time.zone.parse(event.data['review']['submitted_at'])
      review_requested_at = Time.zone.parse(event.data['pull_request']['created_at'])

      (review_attended_at - review_requested_at).seconds
    end
  end
end
