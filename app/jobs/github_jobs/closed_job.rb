module GithubJobs
  class ClosedJob < ActiveJob::Base
    queue_as :closed

    def perform(payload)
      GithubService.call(payload).closed
    end
  end
end
