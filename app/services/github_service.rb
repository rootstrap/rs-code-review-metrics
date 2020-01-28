class GithubService < BaseService
  include PayloadParser

  def initialize(payload)
    @payload = parse_payload(payload)
  end

  def closed
    PullRequest.find_by!(github_id: @payload.pull_request.id).closed!
  end

  def opened
    pr_data = @payload.pull_request
    PullRequest.create!(
      node_id: pr_data.node_id,
      number: pr_data.number,
      state: pr_data.state,
      locked: pr_data.locked,
      draft: pr_data.draft,
      title: pr_data.title,
      body: pr_data.body,
      closed_at: pr_data.closed_at,
      merged_at: pr_data.merged_at,
      merged: pr_data.merged,
      github_id: pr_data.id
    )
  end

  def review_removal
    reviewer = User.find_by!(github_id: @payload.requested_reviewer.id)
    find_pr.review_requests.find_by!(reviewer: reviewer).removed!
  end

  def review_request
    owner = create_or_find_user(@payload.pull_request.user)
    reviewer = create_or_find_user(@payload.requested_reviewer)
    find_pr.review_requests.create!(data: @payload, owner: owner, reviewer: reviewer)
  end

  def create_or_find_user(user_data)
    github_id = user_data.id
    User.find_by(github_id: github_id) ||
      User.create!(
        node_id: user_data.node_id,
        login: user_data.login,
        github_id: github_id
      )
  end

  def find_pr
    PullRequest.find_by!(github_id: @payload.pull_request.id)
  end
end
