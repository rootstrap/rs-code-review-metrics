class DevelopmentMetricsController < ApplicationController
  def index; end

  def projects
    return if metric_params.blank?

    build_metrics(project.id, Project.name)
    @code_owners = project.code_owners.pluck(:login)
  end

  def departments
    return if metric_params.blank?

    build_metrics(department_id, Department.name)
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

  def project
    @project ||= Project.find_by(name: params[:project_name])
  end

  def department_id
    @department_id ||= Department.find_by(name: params[:department_name]).id
  end

  def metric_params
    @metric_params ||= params[:metric]
  end
end
