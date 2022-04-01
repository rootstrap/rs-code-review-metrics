module PullRequests
  class PullRequestsController < ApplicationController
    layout 'sidebar_metrics'
    include LoadSettings
    include DateValidator
    include RepositoryValidator

    before_action :verify_repository_existence

    def index
      validate_from_to(from: metric_params[:from], to: metric_params[:to])
      @pull_requests = repository.call(
        from: @from,
        to: @to,
        repository_name: @repository_name
      )
      respond_to do |format|
        format.html { render :index }
        format.json { render json: @pull_requests.to_json }
      end
    end

    private

    def metric_params
      params.require(:metric).permit(:to, :from)
    end
  end
end
