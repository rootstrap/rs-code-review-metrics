class DevelopmentMetricsController < ApplicationController
  def index
  end

  def project
    return if metric_params.blank?

    build_metrics(project_id, Project.to_s)
  end

  def department
    return if metric_params.blank?

    build_metrics(department_id, Department.to_s)
  end

  private

  def build_metrics(entity_id, entity_name)
    period_metric_query = Metrics::PeriodRetriever.call(metric_params[:period])
    metrics = Builders::Chartkick::DevelopmentMetrics.const_get(entity_name)
                                                     .call(entity_id, period_metric_query)
    @review_turnaround = metrics[:review_turnaround]
    @merge_time = metrics[:merge_time]
    @code_climate = CodeClimateSummaryRetriever.call(entity_id)
  end

  def project_id
    @project_id ||= Project.find_by(name: params[:project_name]).id
  end

  def department_id
    @department_id ||= Department.find_by(name: params[:department_name]).id
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
