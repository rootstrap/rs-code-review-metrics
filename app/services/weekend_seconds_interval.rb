class WeekendSecondsInterval < BaseService
  SECONDS_IN_A_DAY = 864_00

  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
  end

  def call
    weekends_as_seconds = weekends_count * SECONDS_IN_A_DAY
    return weekends_as_seconds unless @end_date.saturday? || @end_date.sunday?

    weekends_as_seconds - seconds_of_last_weekend_day
  end

  def seconds_of_last_weekend_day
    @end_date.end_of_day.to_i - @end_date.to_i
  end

  def weekends_count
    dates_range = @start_date.to_date..@end_date.to_date
    dates_range.select { |day| day.saturday? || day.sunday? }.count
  end
end
