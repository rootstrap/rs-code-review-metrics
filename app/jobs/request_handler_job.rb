class RequestHandlerJob < ApplicationJob
  queue_as :default

  def perform(payload, event)
    GithubService.call(payload: payload, event: event)
  end
end
