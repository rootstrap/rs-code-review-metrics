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
      pr_data = @payload['pull_request']
      removed_reviewer = find_or_create_user(@payload['requested_reviewer'])
      owner = find_or_create_user(pr_data['user'])
      review_request = @entity.review_requests
                              .find_by(owner: owner, reviewer: removed_reviewer, state: 'active')
      review_request.removed! unless review_request.nil?
    end

    def review_requested
      pr_data = @payload['pull_request']
      reviewer = find_or_create_user(@payload['requested_reviewer'])
      owner = find_or_create_user(pr_data['user'])
      review_request = @entity.review_requests.find_or_initialize_by(owner: owner,
                                                                     reviewer: reviewer,
                                                                     state: 'active')
      review_request.save! unless review_request.persisted?
    end
  end
end
