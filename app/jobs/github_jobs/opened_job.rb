module GithubJobs
  class OpenedJob < ActiveJob::Base
    queue_as :opened

    def perform(payload)
      GithubService.call(payload).opened
    end
  end
end
