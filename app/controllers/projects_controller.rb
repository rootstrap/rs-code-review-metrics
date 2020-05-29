class ProjectsController < ApplicationController
  def user_project_metric
    return if metric_params.blank?

    period = metric_params[:period]
    @review_turnaround = Queries::BaseQueryMetric.determinate_metric_period(period)
                                                 .call(
                                                   project_id: project_id,
                                                   metric_name: 'review_turnaround'
                                                 )
    @merge_time = Queries::BaseQueryMetric.determinate_metric_period(period)
                                          .call(
                                            project_id: project_id,
                                            metric_name: 'merge_time'
                                          )
  end

  private

  def project_id
    @project_id ||= Project.find_by(name: params[:project_name]).id
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
