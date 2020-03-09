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
  def ==(other)
    starting_at == other.starting_at && ending_at == other.ending_at
  end

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

  ##
  # Returns the contiguous TimeInterval right next to the receiver.
  # The next TimeInterval starts at the receiver ending_at and has the
  # the same duration as the receiver.
  def next
    self.class.new(starting_at: ending_at, duration: duration)
  end

  ##
  # Returns the daily TimeIntervals contained in the receiver.
  def daily_intervals
    [].tap do |contained_intervals|
      each_partially_included_interval(duration: 1.day) do |daily_interval|
        contained_intervals << daily_interval
      end
    end
  end

  private

  ##
  # Iterates over each TimeInterval of the given duration included in the receiver.
  # Partially included means that if the included interval ends beyond the
  # receiver it is also iterated.
  def each_partially_included_interval(duration:, &iteration_block)
    time_interval = self.class.new(starting_at: starting_at, duration: duration)

    while time_interval.starting_at < ending_at
      iteration_block.call(time_interval)
      time_interval = time_interval.next
    end
  end
end
