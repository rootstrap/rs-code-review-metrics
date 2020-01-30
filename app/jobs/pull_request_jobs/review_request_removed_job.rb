module PullRequestJobs
  class ReviewRequestRemovedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      Github::PullRequestService.call(payload).review_request_removed
    end
  end
end
