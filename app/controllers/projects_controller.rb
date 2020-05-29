class ProjectsController < ApplicationController
<<<<<<< HEAD
  def review_turnaround
    return if params.dig(:metric, :period).blank?

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
=======
  def user_project_metric
    return if metric_params.blank?

    @metrics = Queries::BaseQueryMetric.determinate_metric_period(metric_params[:period]).call(
      project_id: project_id,
      metric_name: metric_params[:name]
    )
>>>>>>> origin
  end

  private

  def project_id
<<<<<<< HEAD
    params[:project_id]
  end

  def metric_params
    params.require(:metric).permit(:period)
=======
    @project_id ||= Project.find_by(name: metric_params[:project_name]).id
  end

  def metric_params
    @metric_params ||= params[:metric]
>>>>>>> origin
  end
end
