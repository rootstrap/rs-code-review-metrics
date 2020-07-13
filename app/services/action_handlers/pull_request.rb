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
      removed_reviewer = find_or_create_user(@payload['requested_reviewer'])
      @entity.review_requests.find_by(reviewer: removed_reviewer, state: 'active')
                             &.removed!
    end

    def review_requested
      raise PullRequests::RequestTeamAsReviewerError if @payload['requested_team']

      Builders::ReviewRequest.call(@entity, @payload)
    end
  end
end
