module GithubService
  class ReviewRemovalWorker
    include Sidekiq::Worker
    include PayloadParser

    def perform(payload)
      payload = parse_payload(payload)
      reviewer = User.find_by!(github_id: payload.requested_reviewer.id)
      pr = PullRequest.find_by!(github_id: payload.pull_request.id)
      pr.review_requests.find_by!(reviewer: reviewer).removed!
    end
  end
end
