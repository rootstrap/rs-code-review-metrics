class ProjectsController < ApplicationController
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
  end

  private

  def project_id
    params[:project_id]
  end

  def metric_params
    params.require(:metric).permit(:period)
  end
end
