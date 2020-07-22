module DropdownSelectionHelper
  def chosen_user
    params.dig(:id) || 0
  end

  def chosen_period
    params.dig(:metric, :period) || 4
  end
end
