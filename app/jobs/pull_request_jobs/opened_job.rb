module PullRequestJobs
  class OpenedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      Github::PullRequestService.call(payload).opened
    end
  end
end
