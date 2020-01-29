module PullRequestJobs
  class ReviewRequestedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      GithubService.call(payload).review_requested
    end
  end
end
