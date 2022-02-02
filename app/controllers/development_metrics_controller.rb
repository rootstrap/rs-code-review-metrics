class DevelopmentMetricsController < ApplicationController
  layout 'sidebar_metrics'
  include LoadSettings
  include DateValidator
  PRODUCTS_ACTION = 'products'.freeze

  def index; end

  def products
    return if metric_params.blank?

    build_product_metrics(product.id, Product.name)
  end

  def repositories
    return if metric_params.blank?

    entity_name = Repository.name

    build_metrics(repository.id, entity_name)
    build_metrics_definitions
    build_success_rates(entity_name)

    @code_owners = repository.code_owners.pluck(:login)
    @code_climate = code_climate_repository_summary
  end

  def departments
    return if metric_params.blank?

    entity_name = Department.name

    build_metrics(department.id, entity_name)
    build_success_rates(entity_name)
    @code_climate = code_climate_department_summary
    @overview = department_overview
  end

  def users; end

  def products_metrics
    return if metric_params.blank?

    build_product_metrics(product.id, Product.name)
  end

  private

  def build_success_rates(entity_name)
    key = "per_#{entity_name.downcase}_distribution".to_sym

    @merge_time_success_rate = @merge_time[key].first[:success_rate]
    @review_turnaround_success_rate = @review_turnaround[key].first[:success_rate]
  end

  def build_metrics(entity_id, entity_name)
    validate_from_to(from: metric_params[:from], to: metric_params[:to])
    metrics = Builders::Chartkick::DevelopmentMetrics.const_get(entity_name)
                                                     .call(entity_id, @from, @to)
    @review_turnaround = metrics[:review_turnaround]
    @merge_time = metrics[:merge_time]
    @pull_request_size = metrics[:pull_request_size]
  end

  def build_product_metrics(entity_id, entity_name)
    validate_from_to(from: metric_params[:from], to: metric_params[:to])
    @has_jira_project = product.jira_board&.present?

    return unless @has_jira_project

    @query_metric_name = metric_params[:name]

    set_metrics_to_show
    metrics = Builders::Chartkick::DevelopmentMetrics.const_get(entity_name)
                                                     .call(entity_id, @from, @to)

    defect_escape_rate(metrics)
    development_cycle(metrics)
    planned_to_done(metrics)
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
    show_planned_to_done
  end

  def metrics_to_show
    case @query_metric_name.to_sym
    when :defect_escape_rate
      @show_defect_escape_rate = true
    when :development_cycle
      @show_development_cycle = true
    when :planned_to_done
      @show_planned_to_done = true
    end
  end

  def defect_escape_rate(metrics)
    return unless @show_defect_escape_rate

    @defect_escape_rate = metrics[:defect_escape_rate]
    @defect_escape_rate_definition = MetricDefinition.find_by(code: :defect_escape_rate)
    @metric_title = @defect_escape_rate_definition
  end

  def development_cycle(metrics)
    return unless @show_development_cycle

    @development_cycle = metrics[:development_cycle]
    @development_cycle_definition = MetricDefinition.find_by(code: :development_cycle)
    @metric_title = @development_cycle_definition
  end

  def planned_to_done(metrics)
    return unless @show_planned_to_done

    @planned_to_done = metrics[:planned_to_done]
    @planned_to_done_definition = MetricDefinition.find_by(code: :planned_to_done)
    @metric_title = @planned_to_done_definition
  end

  def show_defect_escape_rate
    @show_defect_escape_rate ||= product_action
  end

  def show_development_cycle
    @show_development_cycle ||= product_action
  end

  def show_planned_to_done
    @show_planned_to_done ||= product_action
  end

  def product_action
    @product_action ||= action == PRODUCTS_ACTION
  end

  def product
    @product ||= Product.find_by(name: params[:product_name])
  end

  def repository
    @repository ||= Repository.find_by(name: params[:repository_name])
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

  def code_climate_repository_summary
    CodeClimateSummaryRetriever.call(repository.id)
  end

  def code_climate_department_summary
    CodeClimate::RepositoriesSummaryService.call(
      department: department,
      from: metric_params[:from],
      to: metric_params[:to],
      technologies: []
    )
  end

  def department_overview
    Builders::DepartmentOverview.call(department, from: @from, to: @to)
  end
end
