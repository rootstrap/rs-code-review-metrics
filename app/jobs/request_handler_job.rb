class RequestHandlerJob < ApplicationJob
  queue_as :default

  def perform(payload)
    Project.resolve(payload)
  end
end
