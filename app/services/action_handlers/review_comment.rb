module ActionHandlers
  class ReviewComment < ActionHandler
    ACTIONS = %w[created edited deleted].freeze
    private_constant :ACTIONS

    def resolve
      return unless handleable?

      handle_action
    end

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def created
      @event_type.update!(body: @payload['comment']['body'])
    end

    def edited
      @event_type.update!(body: @payload['changes']['body'])
    end

    def deleted
      @event_type.removed!
    end
  end
end
