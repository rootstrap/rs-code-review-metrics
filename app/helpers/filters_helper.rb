module FiltersHelper
  def filter_url_query
    {
      repository_name: params[:repository_name],
      metric: { period: params&.dig(:metric, :period) }
    }
  end

  def current_department
    Department.find_by!(name: params[:department_name])
  end

  def chosen_contribution_period
    params[:from] || 4
  end

  def base_branch_chosen
    params.dig(:metric, :base_branch) || ''
  end
end
