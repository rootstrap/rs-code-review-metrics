class DevelopmentMetricsController < ApplicationController
  def index
    return if metric_params.blank?

    period_metric_query = Metrics::PeriodRetriever.call(metric_params[:period])
    metrics = Builders::Chartkick::DevelopmentMetrics.call(project_id, period_metric_query)
    @review_turnaround = metrics[:review_turnaround]
    @merge_time = metrics[:merge_time]
    @code_climate = CodeClimateSummaryRetriever.call(project_id)
  end

  private

  def project_id
    @project_id ||= Project.find_by(name: params[:project_name]).id
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
