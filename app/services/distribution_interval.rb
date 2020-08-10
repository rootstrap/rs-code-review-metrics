class DistributionInterval < BaseService
  SECONDS_IN_A_DAY = 864_00

  private

  def weekend_days_as_seconds(range_days)
    weekends = range_days.select { |day|
      wday = day.wday
      wday == 6 || wday.zero?
    }.count
    weekends * SECONDS_IN_A_DAY
  end
end
