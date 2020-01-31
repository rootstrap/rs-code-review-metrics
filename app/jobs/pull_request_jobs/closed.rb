module PullRequestJobs
  class Closed < ApplicationJob
    queue_as :default

    def perform(payload)
      Events::PullRequestService.call(payload).closed
    end
  end
end
