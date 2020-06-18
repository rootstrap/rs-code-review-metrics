module DropdownSelectionHelper
  def value_from_metric_param(param)
    params.dig(:metric, param) || 0
  end

  def value_from_project_param
    params.dig(:project_name) || 0
  end

  def value_from_user_param
    params.dig(:code_owner, :user_id) || 0
  end
end
