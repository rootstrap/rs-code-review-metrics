class OpenSourceSlackJob < ApplicationJob
  queue_as :default

  def perform
    SlackService.open_source_reminder
  end
end
