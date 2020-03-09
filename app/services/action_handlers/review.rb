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
      state = @payload['review']['state']
      @entity.public_send("#{state}!")
    end

    def edited
      @entity.update!(body: @payload['changes']['body'])
    end

    def dismissed
      @entity.dismissed!
    end
  end
end
