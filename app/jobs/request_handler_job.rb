class RequestHandlerJob < ApplicationJob
  queue_as :default
  discard_on Events::NotHandleableError

  def perform(payload, event)
    GithubService.call(payload: payload, event: event)
  end
end
