module DropdownSelectionHelper
  def value_from_metric_param(param)
    params.dig(:metric, param) || 0
  end

  def value_from_user_param
    params.dig(:id) || 0
  end

  def value_from_period_param
    params.dig(:metric, :period) || 4
  end
end
