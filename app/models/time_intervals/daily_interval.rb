module TimeIntervals
  ##
  # Iterates over each day between two concrete Times.
  # For regular periods like Daily and Weekly the iteration is fairly straightforward
  # but for Monthly and Yearly periods it has its complexity since they are note
  # regular in duration.
  # This object aims to hide the complexity of iterating through time intervals
  # using the polimorphic :from(starting_at, up_to:) and :next_to(time_interval)
  # methods.
  module DailyInterval
    extend self

    def each_from(starting_at, up_to:, &iteration_block)
      time_interval = containing(starting_at)
      while time_interval.starting_at < up_to
        iteration_block.call(time_interval)
        time_interval = next_to(time_interval)
      end
    end

    ##
    # Returns the contiguous Daily TimeInterval right next to the given one.
    def next_to(time_interval)
      containing(time_interval.ending_at)
    end

    ##
    # Returns a TimeInterval during 1 day starting at the beginning of the day of
    # the given time
    def containing(time)
      TimeInterval.new(starting_at: to_beginning_of_day(time), duration: 1.day).freeze
    end

    ##
    # Returns the beginning of the day of the given time
    def to_beginning_of_day(time)
      ActiveSupport::TimeZone.new(time.zone).parse(time.strftime('%Y-%m-%dT00:00:00'))
    end
  end
end
