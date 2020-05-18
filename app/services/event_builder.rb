class EventBuilder < BaseService
  def initialize(payload:)
    @payload = payload
  end

  def call
    build
  end

  private

  def find_pull_request
    Events::PullRequest.find_by!(github_id: @payload['pull_request']['id'])
  end

  def find_last_review_request(pull_request, reviewer_id)
    pull_request.review_requests.where(reviewer_id: reviewer_id).last
  rescue StandardError
    raise NoReviewRequestError
  end

  def find_or_create_user_project(project_id, user_id)
    UsersProject.find_or_create_by!(project_id: project_id, user_id: user_id)
  end
end
