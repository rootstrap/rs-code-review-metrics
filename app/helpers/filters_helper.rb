module FiltersHelper
  def department_filter?
    params[:department_name].present?
  end

  def department_name_filter
    params[:department_name]
  end

  def filter_url_query
    {
      project_name: params[:project_name],
      metric: { period: params&.dig(:metric, :period) }
    }
  end
end
