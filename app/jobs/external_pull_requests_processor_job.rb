class ExternalPullRequestsProcessorJob < ApplicationJob
  queue_as :default

  def perform(username)
    Processors::External::PullRequests.call(username)
  end
end
