module PullRequestJobs
  class MergedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      GithubService.call(payload).merged
    end
  end
end
