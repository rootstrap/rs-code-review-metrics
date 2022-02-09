module PullRequests
  class PullRequestsController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings
    include DateValidator

    def index
      validate_from_to(from: metric_params[:from], to: metric_params[:to])
      @pull_requests = repository.call(
        from: @from,
        to: @to,
        repository_name: params[:repository_name]
      )
    end

    def metric_params
      params.require(:metric).permit(:to, :from)
    end
  end
end
