module DailyMetrics
  class ReviewTurnaroundJob < ApplicationJob
    queue_as :daily_review_turnaround
    INTERVAL = 'daily'.freeze

    def perform
      Processors::ReviewTurnaround.call(INTERVAL)
    end
  end
end
