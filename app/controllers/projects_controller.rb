class ProjectsController < ApplicationController
  def metrics
    return if params.dig(:metric, :project_name).blank?

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
  end

  private

  def project_id
    Project.find_by(name: params[:metric][:project_name])
  end

  def metric_params
    params.require(:metric).permit(:period)
  end
end
