module PullRequestJobs
  class ReviewRequestRemoved < ApplicationJob
    queue_as :default

    def perform(payload)
      Events::PullRequestService.call(payload).review_request_removed
    end
  end
end
