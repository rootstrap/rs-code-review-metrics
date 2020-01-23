module GithubJobs
  class ReviewRequestJob < ApplicationJob
    queue_as :review_request

    def perform(payload)
      GithubService.call(payload).review_request
    end
  end
end
