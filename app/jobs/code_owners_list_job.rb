class CodeOwnersListJob < ApplicationJob
  queue_as :default

  def perform
    CodeOwners::Request.call
  end
end
