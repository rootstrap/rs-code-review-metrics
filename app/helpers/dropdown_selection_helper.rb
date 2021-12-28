module DropdownSelectionHelper
  def chosen_user
    params.dig(:id) || 0
  end

  def chosen_period
    params.dig(:metric, :period) || 4
  end

  def chosen_from
    params.dig(:metric, :from) || initial_from
  end

  def chosen_to
    params.dig(:metric, :to) || initial_to
  end

  def initial_to
    Time.zone.now.strftime('%Y-%m-%d')
  end

  def initial_from
    (Time.zone.now - 28.days).strftime('%Y-%m-%d')
  end
end
