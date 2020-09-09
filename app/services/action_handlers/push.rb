module ActionHandlers
  class Push < ActionHandler
    private

    def handleable?
      true
    end

    def created
      pull_request = @entity.pull_request

      return unless pull_request

      Builders::PullRequestSize.call(pull_request)
    end
  end
end
