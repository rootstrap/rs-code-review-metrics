module GithubJobs
  class ReviewRemovalJob < ApplicationJob
    queue_as :default

    def perform(payload)
      GithubService.call(payload).review_removal
    end
  end
end
