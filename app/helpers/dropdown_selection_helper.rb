module DropdownSelectionHelper
<<<<<<< HEAD
  def value_from_query_param
    params.dig(:metric, :period)
=======
  def value_from_query_param(param)
    params.dig(:metric, param)
>>>>>>> origin
  end
end
