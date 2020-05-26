class ProjectsController < ApplicationController
  def user_project_metric
    if valid_params?
      period = metric_params[:period]
      @metrics = if period == 'daily'
                   Queries::DailyMetrics.call(
                     project_id: project_id,
                     metric_name: 'review_turnaround'
                   )
                 elsif period == 'weekly'
                   Queries::WeeklyMetrics.call(
                     project_id: project_id,
                     metric_name: 'review_turnaround'
                   )
                 else
                   raise Graph::RangeDateNotSupported
                 end
    else
      not_found
    end
  end

  private

  def valid_params?
    Metric.names.include?(params[:metric_type]) &&
      params[:period].present?
  end
end
