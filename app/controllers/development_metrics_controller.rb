class DevelopmentMetricsController < ApplicationController
  def index; end

  def projects
    return if metric_params.blank?

    build_metrics(project.id, Project.name)
    @code_owners = project.code_owners.pluck(:login)
    @code_climate = code_climate_project_summary
  end

  def departments
    return if metric_params.blank?

    build_metrics(department.id, Department.name)
    @code_climate = code_climate_department_summary
  end

  def users; end

  private

  def build_metrics(entity_id, entity_name)
    metrics = Builders::Chartkick::DevelopmentMetrics.const_get(entity_name)
                                                     .call(entity_id, metric_params[:period])
    @review_turnaround = metrics[:review_turnaround]
    @merge_time = metrics[:merge_time]
  end

  def project
    @project ||= Project.find_by(name: params[:project_name])
  end

  def department
    @department ||= Department.find_by(name: params[:department_name])
  end

  def metric_params
    @metric_params ||= params[:metric]
  end

  def code_climate_project_summary
    CodeClimateSummaryRetriever.call(project.id)
  end

  def code_climate_department_summary
    CodeClimate::ProjectsSummaryService.call(
      department: department,
      from: nil,
      technologies: []
    )
  end
end
