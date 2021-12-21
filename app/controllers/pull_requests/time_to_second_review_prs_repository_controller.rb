module PullRequests
  class TimeToSecondReviewPrsRepositoryController < PullRequestsController
    def repository
      Builders::Distribution::PullRequests::TimeToSecondReviewRepository
    end
  end
end
