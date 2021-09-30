class RequestHandlerJob < ApplicationJob
  queue_as :default
  discard_on Events::NotHandleableError,
             Reviews::NoReviewRequestError,
             PullRequests::RequestTeamAsReviewerError

  retry_on PullRequests::GithubUniquenessError,
           Reviews::ReviewRequestUniquenessError

  def perform(payload, event)
    GithubService.call(payload: payload, event: event)
  end
end
