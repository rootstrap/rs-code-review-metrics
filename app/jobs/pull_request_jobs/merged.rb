module PullRequestJobs
  class Merged < ApplicationJob
    queue_as :default

    def perform(payload)
      Events::PullRequestService.call(payload).merged
    end
  end
end
