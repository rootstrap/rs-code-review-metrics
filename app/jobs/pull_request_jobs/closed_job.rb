module PullRequestJobs
  class ClosedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      Github::PullRequestService.call(payload).closed
    end
  end
end
