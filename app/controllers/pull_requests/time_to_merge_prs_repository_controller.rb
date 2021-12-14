module PullRequests
  class TimeToMergePrsRepositoryController < PullRequestsController
    def index
      @pull_requests = Builders::Distribution::PullRequests::TimeToMergeRepository.call(
        from: metric_params[:period],
        repository_name: params[:repository_name]
      )
    end

    def metric_params
      params.require(:metric).permit(:period)
    end
  end
end
