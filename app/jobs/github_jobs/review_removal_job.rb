module GithubJobs
  class ReviewRemovalJob < ApplicationJob
    queue_as :review_removal

    def perform(payload)
      GithubService.call(payload).review_removal
    end
  end
end
