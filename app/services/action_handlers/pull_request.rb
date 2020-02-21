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
      reviewer = find_user
      @entity.review_requests.find_by!(reviewer: reviewer).removed!
    end

    def review_requested
      owner = find_or_create_user(@payload['pull_request']['user'])
      reviewer = find_or_create_user(@payload['requested_reviewer'])
      @entity.review_requests.create!(owner: owner, reviewer: reviewer,
                                      node_id: reviewer.node_id, login: reviewer.login)
    end
  end
end
