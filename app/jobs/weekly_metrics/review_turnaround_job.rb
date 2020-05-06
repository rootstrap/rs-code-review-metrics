module WeeklyMetrics
  class ReviewTurnaroundJob < ApplicationJob
    queue_as :weekly_review_turnaround
    INTERVAL = 'weekly'.freeze

    def perform
      Processors::ReviewTurnaround.call(INTERVAL)
    end
  end
end
