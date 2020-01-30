module Github
  class PullRequestService < GithubService
    def closed
      pr = Events::PullRequest.find_by!(github_id: @payload.pull_request.id)
                              .update!(closed_at: Time.now)
                              .closed!
      assign_event(pr)
    end

    def merged
      pr = Events::PullRequest.find_by!(github_id: @payload.pull_request.id)
                              .update!(merged_at: Time.current, merged: true)
      assign_event(pr)
    end

    def opened
      pr_data = @payload.pull_request
      pr = Events::PullRequest.create!(
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
      assign_event(pr)
    end

    def review_request_removed
      reviewer = User.find_by!(github_id: @payload.requested_reviewer.id)
      pr = find_pr
      pr.review_requests.find_by!(reviewer: reviewer).removed!
      assign_event(pr)
    end

    def review_requested
      owner = create_or_find_user(@payload.pull_request.user)
      reviewer = create_or_find_user(@payload.requested_reviewer)
      pr = find_pr
      pr.review_requests.create!(data: @payload, owner: owner,
                                 reviewer: reviewer)
      assign_event(pr)
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

    def assign_event(pull_request)
      Event.create!(handleable: pull_request,
                    name: @payload.event,
                    data: @payload)
    end
  end
end
