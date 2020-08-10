class DistributionInterval < BaseService
  SECONDS_IN_A_DAY = 86400

  private

  def weekend_days_as_seconds(range_days)
    weekends = range_days.select { |day| day.wday == 6 || day.wday ==0 }.count
    weekends * SECONDS_IN_A_DAY
  end
end
