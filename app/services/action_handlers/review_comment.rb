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
      update!(body: @payload['comment']['body'])
    end

    def edited
      update!(body: @payload['changes']['body'])
    end

    def deleted
      removed!
    end
  end
end
