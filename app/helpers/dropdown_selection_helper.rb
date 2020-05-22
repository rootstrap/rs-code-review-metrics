module DropdownSelectionHelper
  def value_from_query_param
    params.dig(:metric, :period)
  end
end
