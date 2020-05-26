module ActionHandlers
  class Review < ActionHandler
    ACTIONS = %w[submitted edited dismissed].freeze
    private_constant :ACTIONS

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def submitted
      state = @payload['review']['state']
      return unless valid_state?(state)

      @entity.public_send("#{state}!")
    end

    def edited
      @entity.update!(body: @payload['changes']['body'])
    end

    def dismissed
      @entity.dismissed!
    end

    def valid_state?(state)
      Events::Review.states.key?(state)
    end
  end
end
