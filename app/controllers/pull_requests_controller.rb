class PullRequestsController < ApplicationController
  layout 'sidebar_metrics'

  def index
    @pull_requests = Builders::Distribution::PullRequests.call(
      department_name: params[:department_name],
      from: metric_params[:period],
      languages: metric_params[:lang] || []
    )
  end

  def metric_params
    params.require(:metric).permit(:period, lang: [])
  end
end
