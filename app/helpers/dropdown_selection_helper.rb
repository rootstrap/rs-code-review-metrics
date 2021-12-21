module DropdownSelectionHelper
  def chosen_user
    params.dig(:id) || 0
  end

  def chosen_period
    params.dig(:metric, :period) || 4
  end

  def chosen_from
    params.dig(:metric, :from) || (Time.now - 28.day).strftime("%Y-%m-%d")
  end

  def chosen_to
    params.dig(:metric, :to) || Time.now.strftime("%Y-%m-%d")
  end

end
