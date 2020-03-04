##
# An interval of time between two concrete points in time
class TimeInterval
  ##
  # Creates a TimeInterval starting at the given point in time with the given
  # duration expressed as a number of seconds
  def initialize(starting_at:, duration:)
    @starting_at = starting_at
    @duration = duration
    @closed_end_at = @starting_at + @duration - 0.01.seconds
  end

  attr_reader :starting_at, :duration

  ##
  # Returns true if the TimeInterval includes the given time.
  def includes?(time)
    time.between?(@starting_at, @closed_end_at)
  end
end
