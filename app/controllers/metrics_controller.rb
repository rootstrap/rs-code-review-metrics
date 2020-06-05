class MetricsController < ApplicationController
  def metrics
    return if metric_params.blank?

    period_metric_query = Metrics::PeriodRetriever.call(metric_params[:period])

    @review_turnaround = period_metric_query.call(
      entity_name: controller_name, entity_id: project_id, metric_name: 'review_turnaround'
    )
    @merge_time = period_metric_query.call(
      entity_name: controller_name, entity_id: project_id, metric_name: 'merge_time'
    )
  end

  private

  def project_id
    @project_id ||= Project.find_by(name: params[:project_name]).id
  end

  def controller_name
    @controller_name ||= params[:controller]
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
