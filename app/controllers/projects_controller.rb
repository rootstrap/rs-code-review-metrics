class ProjectsController < ApplicationController
  def user_project_metric
    return if metric_params.blank?

    @metrics = Queries::BaseQueryMetric.determinate_metric_period(metric_params[:period]).call(
      project_id: project_id,
      metric_name: metric_params[:name]
    )
  end

  private

  def project_id
    @project_id ||= Project.find_by(name: metric_params[:project_name]).id
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
