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
  #     - project A, 2020-02-01 => 150
  #     - project B, 2020-02-01 => 110
  #
  # Therefore to generate the metrics from a collection of Github events the
  # ReviewTurnaroundPerProjectProcessor requires the following parameters:
  #
  #     - an interval of time (ej. 1 month)
  #     - the initial point in time for the interval (ej. 2020-01-01)
  #     - the collection of events reveived in that interval
  class ReviewTurnaroundPerProjectProcessor < MetricProcessor
    private

    def process
      review_turnaround_average.each do |project_id:, turnaround_as_seconds:|
        save_value(project_id: project_id, turnaround_as_seconds: turnaround_as_seconds)
      end

      update_last_process_time
    end

    def review_turnaround_average
      @review_turnaround_average ||=
        Queries::ReviewsTurnaroundPerProjectQuery.new(time_interval: time_interval)
    end

    def save_value(project_id:, turnaround_as_seconds:)
      update_metric(
        entity_key: project_id,
        entity_type: Project.to_s,
        value: turnaround_as_seconds,
        value_timestamp: time_interval.starting_at
      )
    end

    def update_last_process_time
      last_processed_review = review_turnaround_average.last_processed_review
      return unless last_processed_review

      metrics_definition.update!(
        last_processed_event_time: last_processed_review.created_at
      )
    end
  end
end
