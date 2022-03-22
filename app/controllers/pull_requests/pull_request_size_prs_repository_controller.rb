module PullRequests
  class PullRequestSizePrsRepositoryController < PullRequestsController
    def repository
      Builders::Distribution::PullRequests::PullRequestSizeRepository
    end
  end
end
