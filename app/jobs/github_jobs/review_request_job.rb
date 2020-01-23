module GithubJobs
  class ReviewRequestJob < ActiveJob::Base
    queue_as :review_request

    def perform(payload)
      GithubService.call(payload).review_request
    end
  end
end
