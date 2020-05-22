module PullRequests
  class RequestTeamAsReviewerError < StandardError
    def message
      'Teams review requests are not supported.'
    end
  end
end
