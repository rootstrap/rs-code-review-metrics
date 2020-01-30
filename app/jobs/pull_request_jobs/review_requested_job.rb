module PullRequestJobs
  class ReviewRequestedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      Github::PullRequestService.call(payload).review_requested
    end
  end
end
