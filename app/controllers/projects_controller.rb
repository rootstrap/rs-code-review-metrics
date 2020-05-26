class ProjectsController < ApplicationController
  def user_project_metric
    if valid_params?
      if params[:period].present?
        @metrics = determinate_metric_period(metric_params[:period]).call(
          project_id: params[:project_id],
          metric_name: params[:metric_type]
        )
      end
    else
      not_found
    end
  end

  private

  def valid_params?
    Metric.names.include?(params[:metric_type])
  end
end
