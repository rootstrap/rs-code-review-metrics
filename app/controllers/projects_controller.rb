class ProjectsController < ApplicationController
  def review_turnaround
    return if params.dig(:metric, :period).blank?

    @metrics = if metric_params[:period] == 'weekly'
                 Queries::WeeklyMetrics.call(project_id)
               else
                 Queries::DailyMetrics.call(project_id)
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
