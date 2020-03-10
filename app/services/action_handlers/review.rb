module ActionHandlers
  class Review < ActionHandler
    ACTIONS = %w[submitted edited dismissed].freeze

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def submitted
      @entity.update!(body: @payload['review']['body'])
    end

    def edited
      @entity.update!(body: @payload['changes']['body'])
    end

    def dismissed
      @entity.removed!
    end
  end
end
