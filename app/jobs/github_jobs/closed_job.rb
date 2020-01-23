module GithubJobs
  class ClosedJob < ApplicationJob
    queue_as :closed

    def perform(payload)
      GithubService.call(payload).closed
    end
  end
end
