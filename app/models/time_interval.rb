##
# An interval of time between two concrete points in time
class TimeInterval
  attr_reader :starting_at, :ending_at

  ##
  # Creates a TimeInterval starting at the given point in time with the given
  # duration expressed as a number of seconds.
  # The TimeInterval is closed at its starting time and opened at its ending time
  #
  #                 [starting_at, ending_at)
  def initialize(starting_at:, duration:)
    @starting_at = starting_at
    @ending_at = @starting_at + duration
  end

  ##
  # Returns true if the TimeInterval includes the given time.
  def includes?(time)
    starting_at <= time && time < ending_at
  end
end
