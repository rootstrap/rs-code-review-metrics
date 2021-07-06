module ActionHandlers
  class Repository < ActionHandler
    ACTIONS = %w[deleted archived unarchived transferred].freeze
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

    def unarchived
      # TODO
    end

    def transferred
      mark_as_deleted
    end

    def mark_as_deleted
      # TODO
    end
  end
end
