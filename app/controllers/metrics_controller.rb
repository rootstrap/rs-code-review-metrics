class MetricsController < ApplicationController
  def metrics
    return if metric_params.blank?

    period_metric_query = Metrics::PeriodRetriever.call(metric_params[:period])

    @review_turnaround = period_metric_query.call(
      entity_name: controller_name, entity_id: project.id, metric_name: 'review_turnaround'
    )
    @merge_time = period_metric_query.call(
      entity_name: controller_name, entity_id: project.id, metric_name: 'merge_time'
    )
    @code_climate = Metrics::CodeClimateSummaryRetriever.call(project.id)
    @code_owners = project.code_owners.pluck(:login)
  end

  private

  def project
    @project ||= Project.find_by(name: params[:project_name])
  end

  def controller_name
    @controller_name ||= params[:controller]
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
