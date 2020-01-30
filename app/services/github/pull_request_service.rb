module Github
  class PullRequestService < GithubService
    include EventAssociator

    def closed
      assign_event(@payload, close_pr)
    end

    def merged
      assign_event(@payload, merge_pr)
    end

    def opened
      assign_event(@payload, open_pr)
    end

    def review_request_removed
      assign_event(@payload, remove_review_request)
    end

    def review_requested
      assign_event(@payload, assign_review_request)
    end

    private

    def merge_pr
      pr = find_pr
      pr.update!(merged_at: Time.current, merged: true)
      pr
    end

    def remove_review_request
      reviewer = User.find_by!(github_id: @payload.requested_reviewer.id)
      pr = find_pr
      pr.review_requests.find_by!(reviewer: reviewer).removed!
      pr
    end

    def assign_review_request
      owner = create_or_find_user(@payload.pull_request.user)
      reviewer = create_or_find_user(@payload.requested_reviewer)
      pr = find_pr
      pr.review_requests.create!(data: @payload, owner: owner,
                                 reviewer: reviewer)
    end

    def close_pr
      pr = find_pr
      pr.closed!
      pr.update!(closed_at: Time.current)
      pr
    end

    def open_pr
      pr_data = @payload.pull_request
      Events::PullRequest.create!(
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
      Events::PullRequest.find_by!(github_id: @payload.pull_request.id)
    end
  end
end
