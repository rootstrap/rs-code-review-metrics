module ActionHandlers
  class Repository < ActionHandler
    ACTIONS = %w[deleted archived transferred].freeze
    private_constant :ACTIONS

    private

    def handleable?
      ACTIONS.include?(@payload['action'])
    end

    def deleted
      mark_as_deleted
    end

    def archived
      mark_as_deleted
    end

    def transferred
      mark_as_deleted if from_organization?
    end

    def mark_as_deleted
      @entity.repository.destroy!
    end

    def from_organization?
      owner = @payload['changes']['owner']
      owner && owner['from']['organization']['login'] == ENV.fetch('GITHUB_ORGANIZATION')
    end
  end
end
