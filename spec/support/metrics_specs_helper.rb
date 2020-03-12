require 'rails_helper'

# Shared context for testing metrics.
# This shared context does:
#
#   - call :create_test_events and :process_all_events before each test
#
#   - define the following shortcuts to generate testing events:
#     - create_pull_request_event
#     - create_pull_request_event
#     - create_review_event
#     - create_review_comment_event
#
#   - define the following for processing the existing events:
#     - events_to_process
#     - process_all_events
#
#   - define the following shortcuts for the test expectations:
#       - generated_metrics
#       - generated_metrics_count
#       - first_metric
#       - first_metric_value_expressed_as_seconds
#       - second_metric
#       - second_metric_value_expressed_as_seconds
#       - first_metric
#       - first_metric
RSpec.shared_context 'events metrics', shared_context: :metadata do
  before do
    create_test_events
    process_all_events
  end

  let(:metrics_definition) { create :metrics_definition }
  let(:create_test_events) {}

  def events_to_process
    Event.all
  end

  # RFC where should these methods be defined? The make reference to :subject
  def process_all_events
    subject.call(metrics_definition: metrics_definition,
                 events: events_to_process,
                 time_interval: time_interval_to_process)
  end

  def generated_metrics
    Metric.all
  end

  def generated_metrics_count
    Metric.count
  end

  def first_metric
    Metric.first
  end

  def first_metric_value_expressed_as_seconds
    first_metric.value.seconds
  end

  def second_metric
    Metric.second
  end

  def second_metric_value_expressed_as_seconds
    second_metric.value.seconds
  end

  # Note:
  #   The spec factories of the model are not trivial to build since they need to
  #   replicate the same relations between webhook events and models, having
  #   crossed and redundant relations (each event holds a copy of the project and
  #   PR for example).
  #   Until the factories are finished and to avoid blocking the testing of the
  #   metrics the tests populate the models evaluating the same service that the
  #   app evaluates when a webhook arrives providing the customized payloads for
  #   each test. This will help in debugging only the metris or only the factories,
  #   one at a time.

  ##
  # Create a PullRequestEvent event as it would come from github for the testing
  # repository.
  # Return the created event payload.
  def create_pull_request_event(action:, created_at:, repository_payload: nil)
    repository_payload ||= test_repository_a_payload
    create(:pull_request_payload,
           repository: repository_payload,
           action: action,
           created_at: created_at).tap do |payload|
      GithubService.call(payload: payload, event: 'pull_request')
    end
  end

  ##
  # Create a ReviewEvent event as it would come from github for the testing
  # repository and a given PullRequest payload.
  # Return the created event payload.
  def create_review_event(action:,
                          submitted_at:, pull_request_event_payload:,
                          repository_payload: nil)
    repository_payload ||= test_repository_a_payload
    create(:review_payload,
           repository: repository_payload,
           pull_request: pull_request_event_payload['pull_request'],
           action: action,
           submitted_at: submitted_at).tap do |payload|
      GithubService.call(payload: payload, event: 'review')
    end
  end

  ##
  # Create a ReviewCommentEvent event as it would come from github for the testing
  # repository and a given PullRequest payload.
  # Return the created event payload.
  def create_review_comment_event(pull_request_event_payload:, repository_payload: nil)
    repository_payload ||= test_repository_a_payload
    create(:review_comment_payload,
           repository: repository_payload,
           pull_request: pull_request_event_payload['pull_request']).tap do |payload|
      GithubService.call(payload: payload, event: 'review_comment')
    end
  end
end
