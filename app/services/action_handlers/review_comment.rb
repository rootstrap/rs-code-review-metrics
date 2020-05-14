module ActionHandlers
  class ReviewComment < ActionHandler
    ACTIONS = %w[created edited deleted].freeze
    private_constant :ACTIONS

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def created
      mark_review_request_as_reviewed
      @entity.update!(body: @payload['comment']['body'])
    end

    def edited
      @entity.update!(body: @payload['changes']['body'])
    end

    def deleted
      @entity.removed!
    end

    def mark_review_request_as_reviewed
      review_request = ReviewRequest.find_by(pull_request_id: @entity.pull_request_id,
                                             reviewer: @entity.owner,
                                             state: 'active')
      review_request.reviewed! unless review_request.nil?
    end
  end
end
