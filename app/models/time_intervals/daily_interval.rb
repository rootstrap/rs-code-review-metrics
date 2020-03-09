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
    def self.each_from(starting_at, up_to:, &iteration_block)
      time_interval = TimeInterval.new(starting_at: starting_at, duration: 1.day)
      while time_interval.starting_at < up_to
        iteration_block.call(time_interval)
        time_interval = next_to(time_interval)
      end
    end

    ##
    # Returns the contiguous Daily TimeInterval right next to the given one.
    def self.next_to(time_interval)
      at(time_interval.ending_at)
    end

    def self.at(time)
      TimeInterval.new(starting_at: time, duration: 1.day)
    end
  end
end
