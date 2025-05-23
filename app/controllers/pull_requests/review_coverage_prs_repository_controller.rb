module PullRequests
  class ReviewCoveragePrsRepositoryController < PullRequestsController
    def repository
      Builders::Distribution::PullRequests::ReviewCoverageRepository
    end
  end
end
