class ProjectsController < ApplicationController
  def review_turnaround
    @metrics = Queries::DailyMetrics.call(params[:project_id])
  end
end
