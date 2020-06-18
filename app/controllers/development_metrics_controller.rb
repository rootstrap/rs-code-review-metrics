class DevelopmentMetricsController < ApplicationController
  def index
    return if metric_params.blank?

<<<<<<< HEAD
    period_metric_query = Metrics::PeriodRetriever.call(metric_params[:period])
    metrics = Builders::Chartkick::DevelopmentMetrics.call(project_id, period_metric_query)
    @review_turnaround = metrics[:review_turnaround]
    @merge_time = metrics[:merge_time]
    @code_climate = CodeClimateSummaryRetriever.call(project_id)
=======
    @review_turnaround = metrics[:review_turnaround]
    @merge_time = metrics[:merge_time]
    @code_climate = CodeClimateSummaryRetriever.call(project.id)
    @code_owners = project.code_owners.pluck(:login)
>>>>>>> 5962d374ca096e1f7b8ce2b82535b2e3281ab2cb
  end

  private

  def project
    @project ||= Project.find_by(name: params[:project_name])
  end

  def period_metric_query
    @period_metric_query ||= Metrics::PeriodRetriever.call(metric_params[:period])
  end

  def metrics
    @metrics ||= Builders::Chartkick::DevelopmentMetrics.call(project.id, period_metric_query)
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
