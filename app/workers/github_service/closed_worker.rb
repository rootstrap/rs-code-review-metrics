module GithubService
  class ClosedWorker
    include Sidekiq::Worker
    include PayloadParser

    def perform(payload)
      payload = parse_payload(payload)
      PullRequest.find_by!(github_id: payload.pull_request.id).closed!
    end
  end
end
