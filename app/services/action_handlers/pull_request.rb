module ActionHandlers
  class PullRequest < ActionHandler
    ACTIONS = %w[open review_requested closed \
                 review_request_removed].freeze
    private_constant :ACTIONS

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def open
      @entity.open!
      @entity.update!(opened_at: Time.current)
    end

    def merged
      @entity.update!(merged_at: Time.current)
    end

    def closed
      merged if @payload['pull_request']['merged'] == true
      @entity.closed!
      @entity.update!(closed_at: Time.current)
    end

    def review_request_removed
      reviewer = User.find_by!(github_id: @payload['pull_request']['requested_reviewers']
                                            .first['id'])
      @entity.review_requests.find_by!(reviewer: reviewer).removed!
    end

    def review_requested
      pr_data = @payload['pull_request']
      owner = find_or_create_user(pr_data['user'])
      reviewer = find_or_create_user(pr_data['requested_reviewers'].first)
      @entity.review_requests.create!(owner: owner, reviewer: reviewer)
    end
  end
end
