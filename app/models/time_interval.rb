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
  # Returns the hashed value of the receiver.
  # It must be consistent with the :== operand to allow its inclusion
  # in Sets and to be used as Hash keys.
  def hash
    starting_at.hash | ending_at.hash
  end

  ##
  # Returns true if the receiver is equal to the given time_interval
  def eql?(other)
    starting_at == other.starting_at && ending_at == other.ending_at
  end
  alias == eql?

  ##
  # Returns true if the TimeInterval includes the given time.
  def includes?(time)
    starting_at <= time && time < ending_at
  end

  ##
  # Returns the duration of the receiver
  def duration
    ending_at - starting_at
  end
end
