module GithubService
  class ReviewRequestWorker
    include Sidekiq::Worker
    include PayloadParser

    def perform(payload)
      payload = parse_payload(payload)
      owner = create_or_find_user(payload.pull_request.user)
      reviewer = create_or_find_user(payload.requested_reviewer)
      pr = PullRequest.find_by!(github_id: payload.pull_request.id)
      pr.review_requests.create!(data: payload, owner: owner, reviewer: reviewer)
    end

    def create_or_find_user(user_data)
      User.find_by(github_id: user_data.id) ||
        User.create!(
          node_id: user_data.node_id,
          login: user_data.login,
          github_id: user_data.id
        )
    end
  end
end
