##
# An interval of time between two concrete points in time
class TimeInterval
  ##
  # Creates a TimeInterval stargin at the given point in time with the given
  # duration expressed as a number of seconds
  def initialize(starting_at:, duration:)
    @starting_at = starting_at
    @duration = duration
  end

  attr_reader :starting_at, :duration
end
