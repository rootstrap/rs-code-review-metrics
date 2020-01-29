module PullRequestJobs
  class ClosedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      GithubService.call(payload).closed
    end
  end
end
