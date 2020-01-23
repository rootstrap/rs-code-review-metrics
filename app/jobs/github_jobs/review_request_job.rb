module GithubJobs
  class ReviewRequestJob < ApplicationJob
    queue_as :default

    def perform(payload)
      GithubService.call(payload).review_request
    end
  end
end
