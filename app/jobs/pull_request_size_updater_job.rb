class PullRequestSizeUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::PullRequestSizeUpdater.call
  end
end
