module PullRequestJobs
  class MergedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      Github::PullRequestService.call(payload).merged
    end
  end
end
