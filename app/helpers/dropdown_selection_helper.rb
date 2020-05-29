module DropdownSelectionHelper
  def value_from_query_param(param)
    params.dig(:metric, param)
  end
end
