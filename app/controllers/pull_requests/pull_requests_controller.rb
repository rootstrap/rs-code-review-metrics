module PullRequests
  class PullRequestsController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings

    def index
      validate_dates
      @pull_requests = repository.call(
        from: @from,
        to: @to,
        repository_name: params[:repository_name]
      )
    end

    def metric_params
      params.require(:metric).permit(:to, :from)
    end

    def validate_dates
      @from = metric_params[:from]
      @to = metric_params[:to]
      return if @to.blank? || @from.blank?
      return if @to > @from

      flash.now[:notice] = 'From Date Should Be Less Than To Date'
      @from = @to
    end
  end
end
