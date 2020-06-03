class UsersProjectsController < ApplicationController
  def metrics
    return if metric_params.blank?

    period_metric_query = Queries::PeriodMetricRetriever.call(metric_params[:period])

    @review_turnaround = period_metric_query.call(
      project_id: project_id, metric_name: 'review_turnaround'
    )
    @merge_time = period_metric_query.call(
      project_id: project_id, metric_name: 'merge_time'
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
