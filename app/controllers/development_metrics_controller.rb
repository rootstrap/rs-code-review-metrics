class DevelopmentMetricsController < ApplicationController
  layout 'sidebar_metrics'
  include LoadSettings

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
    build_success_rates
    @code_climate = code_climate_department_summary
    @overview = department_overview
  end

  def users; end

  private

  def build_success_rates
    @merge_time_success_rate = @merge_time[:per_department_distribution].first[:success_rate]
    @review_turnaround_success_rate = @review_turnaround[:per_department_distribution]
                                      .first[:success_rate]
  end

  def build_metrics(entity_id, entity_name)
    metrics = Builders::Chartkick::DevelopmentMetrics.const_get(entity_name)
                                                     .call(entity_id, metric_params[:period])
    @review_turnaround = metrics[:review_turnaround]
    @merge_time = metrics[:merge_time]
    @pull_request_size = metrics[:pull_request_size]
    @defect_escape_rate = metrics[:defect_escape_rate]
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
      from: metric_params[:period],
      technologies: []
    )
  end

  def department_overview
    Builders::DepartmentOverview.call(department, from: metric_params[:period].to_i.weeks.ago)
  end
end
