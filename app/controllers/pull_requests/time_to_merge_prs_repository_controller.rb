module PullRequests
  class TimeToMergePrsRepositoryController < PullRequestsController
    def repository
      Builders::Distribution::PullRequests::TimeToMergeRepository
    end
  end
end
