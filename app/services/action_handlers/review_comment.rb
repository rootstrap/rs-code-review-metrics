module ActionHandlers
  class ReviewComment < ActionHandler
    ACTIONS = %w[created edited deleted].freeze

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def created
      @entity.update!(body: @payload['comment']['body'])
    end

    def edited
      @entity.update!(body: @payload['changes']['body'])
    end

    def deleted
      @entity.removed!
    end
  end
end
