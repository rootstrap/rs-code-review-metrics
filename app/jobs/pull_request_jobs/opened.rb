module PullRequestJobs
  class Opened < ApplicationJob
    queue_as :default

    def perform(payload)
      Events::PullRequestService.call(payload).opened
    end
  end
end
