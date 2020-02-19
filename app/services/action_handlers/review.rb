module ActionHandlers
  class Review < ActionHandler
    ACTIONS = %w[submitted edited dismissed].freeze
    private_constant :ACTIONS

    def resolve
      return unless handleable?

      handle_action
    end

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def submitted
      update!(body: @payload['review']['body'])
    end

    def edited
      update!(body: @payload['changes']['body'])
    end

    def dismissed
      removed!
    end
  end
end
