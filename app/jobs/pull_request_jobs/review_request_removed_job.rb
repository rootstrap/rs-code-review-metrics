module PullRequestJobs
  class ReviewRequestRemovedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      GithubService.call(payload).review_request_removed
    end
  end
end
