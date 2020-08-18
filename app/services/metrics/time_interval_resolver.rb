module Metrics
  class TimeIntervalResolver < BaseService
    def initialize(value)
      @value = value
    end

    def call
      if @value < 12
        '1-12'
      elsif  @value < 24
        '12-24'
      elsif  @value < 36
        '24-36'
      elsif  @value < 48
        '36-48'
      elsif  @value < 60
        '48-60'
      elsif  @value < 72
        '60-72'
      else
        '72+'
      end
    end
  end
end
