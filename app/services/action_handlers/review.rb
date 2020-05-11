module ActionHandlers
  class Review < ActionHandler
    ACTIONS = %w[submitted edited dismissed].freeze
    private_constant :ACTIONS

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    # Sets state depending on the state that we receive from the payload
    def submitted
      @entity.review_request.reviewed!
      @state = @payload['review']['state']
      return unless valid_state?

      @entity.public_send("#{@state}!")
    end

    def edited
      @entity.update!(body: @payload['changes']['body'])
    end

    def dismissed
      @entity.dismissed!
    end

    def valid_state?
      Events::Review.states.key?(@state)
    end
  end
end
