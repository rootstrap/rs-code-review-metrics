module GithubService
  class OpenedWorker
    include Sidekiq::Worker
    include PayloadParser

    def perform(payload)
      pr_data = parse_payload(payload).pull_request
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
  end
end
