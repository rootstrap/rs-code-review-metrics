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
  #
  # The review_turnaround metric is generated for:
  #     - a project (in the future it will also be for a user and user/project)
  #       and
  #     - a time interval
  #
  # For example, given two projects A and B and a daily interval the ReviewTurnaroundProcessor
  # would generate the following metrics:
  #
  #     - project A, 2020-01-01 => 100
  #     - project B, 2020-01-01 => 20
  #     - project A, 2020-01-02 => 130
  #     - project B, 2020-01-02 => 120
  #
  # For the same project and a monthly interval generates the following metrics
  #
  #     - project A, 2020-01-01 => 320
  #     - project B, 2020-01-01 => 140
  #     - project A, 2020-02-00 => 150
  #     - project B, 2020-02-00 => 110
  #
  # Therefore to generate the metrics from a collection of Github events the
  # ReviewTurnaroundProcessor requires the following parameters:
  #
  #     - an interval of time (ej. 1 month)
  #     - the initial point in time for the interval (ej. 2020-01-01)
  #     - the collection of events reveived in that interval
  class ReviewTurnaroundProcessor < Metric
    private

    ##
    # Processes the given events to generate the review_turnaround metrics.
    def process_events(events:, time_interval:)
      review_turnaround_per_project = collect_review_turnaround_per_project(events: events)

      update_metrics(value_timestamp: time_interval.starting_at,
                     review_turnaround_per_project: review_turnaround_per_project)
    end

    def collect_review_turnaround_per_project(events:)
      review_turnaround_per_project = Hash.new { |hash, key| hash[key] = [] }
      pull_request_reviewed_track = {}

      events.each do |event|
        next if skip_event?(event: event)

        pull_request_id = event.data['pull_request']['id']
        next if pull_request_reviewed_track.key?(pull_request_id)

        review_turnaround_value = review_turnaround_as_seconds(event: event)
        review_turnaround_per_project[event.project.name] << review_turnaround_value

        pull_request_reviewed_track[pull_request_id] = :reviewed
      end

      review_turnaround_per_project
    end

    ##
    # Updates the metrics for all the project in the given review_turnaround_per_project
    def update_metrics(value_timestamp:, review_turnaround_per_project:)
      review_turnaround_per_project.each_pair do |project_id, values|
        average_value = values.sum / values.size

        update_metric(
          entity_key: project_id,
          metric_key: 'review_turnaround',
          value: average_value,
          value_timestamp: value_timestamp
        )
      end
    end

    def process_event?(event:)
      event.name == 'review'
    end

    ##
    # Process a single event.
    # If the event is not related to a turn around event it ignores it.
    def process_event(event:, &value_block)
      value_block.call(review_turnaround_as_seconds(event: event))
    end

    ##
    # Returns the review turnaround value for the given event.
    def review_turnaround_as_seconds(event:)
      # RFC should we move these times to the Event model?
      reviewed_at = Time.zone.parse(event.data['review']['submitted_at'])
      review_requested_at = Time.zone.parse(event.data['pull_request']['created_at'])

      (reviewed_at - review_requested_at).seconds
    end

    ##
    # The review turnaround metric is only interested in the first review of a PR.
    # This method returns true if the PR of the given review_event was already reviewed.
    #
    # A review_event is the first review of a PR if:
    #     - its action = 'submitted'
    #       &&
    #     - its PR has exactly one Review (the one created by this very same review_event)
    #
    # In all other cases the pull_request linked to this review_event was already
    # reviewed and the review_event is ignored for the review_turnaround metric
    def skip_event?(event:)
      event.name != 'review' ||
        event.data['action'] != 'submitted'
    end
  end
end
