class ProjectsController < ApplicationController
  def review_turnaround
    return @metrics = weekly_metric_query if params[:period] == 'weekly'
    @metrics = daily_metric_query
  end

  def daily_metric_query
    Queries::DailyMetrics.call(params[:project_id])
  end

  def weekly_metric_query
    Queries::WeeklyMetrics.call(params[:project_id])
  end
end
