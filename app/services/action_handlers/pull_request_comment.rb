module ActionHandlers
  class PullRequestComment < ActionHandler
    ACTIONS = %w[created edited deleted].freeze
    private_constant :ACTIONS

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def created
      @entity.update!(body: @payload['comment']['body'])
    end

    def edited
      @entity.update!(body: @payload['changes']['body'])
      @entity.edited!
    end

    def deleted
      @entity.deleted!
    end
  end
end
