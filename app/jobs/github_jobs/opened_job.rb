module GithubJobs
  class OpenedJob < ApplicationJob
    queue_as :default

    def perform(payload)
      GithubService.call(payload).opened
    end
  end
end
