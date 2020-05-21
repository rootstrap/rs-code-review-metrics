class ProjectsController < ApplicationController
  before_action :set_params

  def user_project_metric
    if valid_params?
      @metrics = Queries::DailyMetrics.call(params[:project_id], params[:metric_type])
    else
      render file: 'public/404.html', status: :not_found
    end
  end

  private

  def set_params
    params.permit(:project_id, :metric_type)
  end

  def valid_params?
    Metric.names.include?(params[:metric_type])
  end
end
