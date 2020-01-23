module GithubJobs
  class OpenedJob < ApplicationJob
    queue_as :opened

    def perform(payload)
      GithubService.call(payload).opened
    end
  end
end
