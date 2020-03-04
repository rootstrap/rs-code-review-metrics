module Metrics
  ##
  # Does the processing of the given events to generate the review_turnaround
  # metric for each project.
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
  # This processor generates a review_turnaround metric for:
  #     - each project
  #     in
  #     - a time interval (like 'daily', 'weekly', 'all_times')
  #
  # For example, given two projects A and B and a daily interval the
  # ReviewTurnaroundPerProjectProcessor would generate the following metrics:
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
  # ReviewTurnaroundPerProjectProcessor requires the following parameters:
  #
  #     - an interval of time (ej. 1 month)
  #     - the initial point in time for the interval (ej. 2020-01-01)
  #     - the collection of events reveived in that interval
  class ReviewTurnaroundPerProjectProcessor < BaseMetricProcessor
    attr_reader :review_turnaround_per_project, :pull_request_reviewed

    ##
    # @review_turnaround_per_project: { project_id: review_turnaround_value }
    #   Keeps the values of the review_turnaround for each project.
    #   Allows to calculate the metrics for all the projects in a single pass.
    #
    # @pull_request_reviewed: { pull_request_id: true|nil }
    #   A PullRequest can have many Review events. The
    #   review_turnaround only considers the first Review. This flag is set
    #   to true if a previous Review event was the first Review to ignore all
    #   the Review events after that one.
    def initialize(events:, time_interval:)
      super

      @review_turnaround_per_project = Hash.new { |hash, key| hash[key] = [] }
      @pull_request_reviewed = {}
    end

    private

    def process_event(event:)
      pull_request_id = event.data['pull_request']['id']

      review_turnaround_value = review_turnaround_as_seconds(event: event)
      review_turnaround_per_project[event.project.name] << review_turnaround_value
      pull_request_reviewed[pull_request_id] = :reviewed
    end

    ##
    # Updates the metrics for all the project in the given review_turnaround_per_project
    def update_metrics
      review_turnaround_per_project.each_pair do |project_id, values|
        average_value = values.sum / values.size

        update_metric(
          entity_key: project_id,
          metric_key: 'review_turnaround',
          value: average_value,
          value_timestamp: time_interval.starting_at
        )
      end
    end

    ##
    # Returns the review turnaround value for the given event.
    def review_turnaround_as_seconds(event:)
      payload = event.data

      # RFC should we move these times to the Event model?
      reviewed_at = parse_time(payload['review']['submitted_at'])
      review_requested_at = parse_time(payload['pull_request']['created_at'])

      (reviewed_at - review_requested_at).seconds
    end

    def parse_time(time_string)
      Time.zone.parse(time_string)
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
      payload = event.data
      event.name != 'review' ||
        payload['action'] != 'submitted' ||
        pull_request_reviewed.key?(payload['pull_request']['id']) ||
        !time_interval.includes?(parse_time(payload['review']['submitted_at']))
    end
  end
end
