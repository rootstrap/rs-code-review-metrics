module PullRequests
  class TimeToMergePrsRepositoryController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings

    def index
      @pull_requests_repository = Builders::Distribution::PullRequests::TimeToMergeRepository.call(
        from: metric_params[:period],
        repository_name: params[:repository_name]
      )
    end

    def metric_params
      params.require(:metric).permit(:period)
    end
  end
end
