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
      @event_type.open!
      @event_type.update!(opened_at: Time.current)
    end

    def merged
      @event_type.update!(merged_at: Time.current)
    end

    def closed
      merged if @payload['pull_request']['merged'] == true
      @event_type.closed!
      @event_type.update!(closed_at: Time.current)
    end

    def review_request_removed
      reviewer = find_user
      @event_type.review_requests.find_by!(reviewer: reviewer).removed!
    end

    def review_requested
      owner = find_or_create_user(@payload['pull_request']['user'])
      reviewer = find_or_create_user(@payload['requested_reviewer'])
      @event_type.review_requests.create!(owner: owner, reviewer: reviewer,
                                          node_id: reviewer.node_id, login: reviewer.login)
    end
  end
end
