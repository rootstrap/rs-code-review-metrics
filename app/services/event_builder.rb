class EventBuilder < BaseService
  def initialize(payload:, event:)
    @payload = payload
    @event = event
  end

  def call
    build
  end

  private

  def find_pull_request
    Events::PullRequest.find_by!(github_id: @payload['pull_request']['id'])
  end

  def find_first_review_request(pull_request_id, reviewer_id)
    Events::PullRequest.find(pull_request_id)
                       .review_requests
                       .where(reviewer: reviewer_id)
                       .minimum(:created_at)
  end
end
