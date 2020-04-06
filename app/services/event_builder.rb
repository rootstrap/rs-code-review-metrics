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

  def find_or_create_review_request(pull_request, reviewer_id)
    review_requests = pull_request.review_requests.where(reviewer_id: reviewer_id)
    if review_requests.empty?
      ReviewRequest.create(owner: pull_request.owner,
                           reviewer_id: reviewer_id,
                           pull_request: pull_request)
    else
      review_requests.order(:created_at).first
    end
  end
end
