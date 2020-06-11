class CodeOwnersListJob < ApplicationJob
  queue_as :default

  def perform
    CodeOwnersService.call
  end
end
