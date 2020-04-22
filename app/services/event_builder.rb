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

  def find_or_create_review_request(pull_request, reviewer_id)
    review_requests = pull_request.review_requests.where(reviewer_id: reviewer_id)
    if review_requests.empty?
      ReviewRequest.create!(owner: pull_request.owner,
                            reviewer_id: reviewer_id,
                            pull_request: pull_request)
    else
      review_requests.order(:created_at).first
    end
  end

  def find_or_create_user_project(project_id, user_id)
    UsersProject.find_or_create_by!(project_id: project_id, user_id: user_id)
  end
end
