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
      if @payload['pull_request']['merged']
        merged
      else
        @entity.pull_request_size&.destroy!
      end

      @entity.closed!
      @entity.update!(closed_at: Time.current)
    end

    def review_request_removed
      validate_requested_team

      removed_reviewer = find_or_create_user(@payload['requested_reviewer'])
      @entity.review_requests.find_by(reviewer: removed_reviewer, state: 'active')
                             &.removed!
    end

    def review_requested
      validate_requested_team

      Builders::ReviewRequest.call(@entity, @payload)
    end

    def validate_requested_team
      raise PullRequests::RequestTeamAsReviewerError if @payload['requested_team']
    end
  end
end
