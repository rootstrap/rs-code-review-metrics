module DropdownSelectionHelper
  def value_from_metric_param(param)
    params.dig(:metric, param)
  end

  def value_from_param(param)
    params.dig(param) || 0
  end

  def value_from_user_param
    params.dig(:code_owner, :user_id) || 0
  end
end
