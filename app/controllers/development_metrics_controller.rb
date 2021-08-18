class DevelopmentMetricsController < ApplicationController
  layout 'sidebar_metrics'
  include LoadSettings

  PRODUCTS_ACTION = 'products'.freeze

  def index; end

  def products
    return if metric_params.blank?

    build_product_metrics(product.id, Product.name)
  end

  def projects
    return if metric_params.blank?

    build_metrics(project.id, Project.name)
    build_metrics_definitions

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

  def products_metrics
    return if metric_params.blank?

    build_product_metrics(product.id, Product.name)
  end

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
  end

  def build_product_metrics(entity_id, entity_name)
    @has_jira_project = product.jira_board&.present?

    return unless @has_jira_project

    @query_metric_name = metric_params[:name]

    set_metrics_to_show

    metrics = Builders::Chartkick::DevelopmentMetrics.const_get(entity_name)
                                                     .call(entity_id, metric_params[:period])

    defect_escape_rate(metrics)
    development_cycle(metrics)
  end

  def build_metrics_definitions
    @review_turnaround_definition = MetricDefinition.find_by(code: :review_turnaround)
    @merge_time_definition = MetricDefinition.find_by(code: :merge_time)
    @pull_request_size_definition = MetricDefinition.find_by(code: :pull_request_size)
  end

  def set_metrics_to_show
    metrics_to_show if @query_metric_name.present?

    show_defect_escape_rate
    show_development_cycle
  end

  def metrics_to_show
    case @query_metric_name.to_sym
    when :defect_escape_rate
      @show_defect_escape_rate = true
    when :development_cycle
      @show_development_cycle = true
    end
  end

  def defect_escape_rate(metrics)
    return unless @show_defect_escape_rate

    @defect_escape_rate = metrics[:defect_escape_rate]
    @defect_escape_rate_definition = MetricDefinition.find_by(code: :defect_escape_rate)
  end

  def development_cycle(metrics)
    return unless @show_development_cycle

    @development_cycle = metrics[:development_cycle]
    @development_cycle_definition = MetricDefinition.find_by(code: :development_cycle)
  end

  def show_defect_escape_rate
    @show_defect_escape_rate ||= product_action
  end

  def show_development_cycle
    @show_development_cycle ||= product_action
  end

  def product_action
    @product_action ||= action == PRODUCTS_ACTION
  end

  def product
    @product ||= Product.find_by(name: params[:product_name])
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

  def action
    @action ||= params[:action]
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
