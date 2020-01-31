module PullRequestJobs
  class ReviewRequested < ApplicationJob
    queue_as :default

    def perform(payload)
      Events::PullRequestService.call(payload).review_requested
    end
  end
end
