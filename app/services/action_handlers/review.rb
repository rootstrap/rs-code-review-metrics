module ActionHandlers
  class Review < ActionHandler
    ACTIONS = %w[submitted edited dismissed].freeze
    private_constant :ACTIONS

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def submitted
      @event_type.update!(body: @payload['review']['body'])
    end

    def edited
      @event_type.update!(body: @payload['changes']['body'])
    end

    def dismissed
      @event_type.removed!
    end
  end
end
