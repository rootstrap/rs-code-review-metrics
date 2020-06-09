class MetricsController < ApplicationController
  def index
    return if metric_params.blank?

    period_metric_query = Metrics::PeriodRetriever.call(metric_params[:period])
    @review_turnaround = Builders::ReviewTurnaroundMetrics.call(project_id, period_metric_query)
    @merge_time = Builders::MergeTimeMetrics.call(project_id, period_metric_query)
    @code_climate = Metrics::CodeClimateSummaryRetriever.call(project_id)
  end

  private

  def project_id
    @project_id ||= Project.find_by(name: params[:project_name]).id
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
