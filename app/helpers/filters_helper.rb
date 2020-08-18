module FiltersHelper
  def filter_url_query
    {
      project_name: params[:project_name],
      metric: { period: params&.dig(:metric, :period) }
    }
  end

  def current_department
    Department.find_by(name: params[:department_name])
  end
end
