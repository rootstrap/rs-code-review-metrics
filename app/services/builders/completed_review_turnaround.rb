module Builders
  class CompletedReviewTurnaround < BaseService
    def initialize(review)
      @review = review
    end

    def call
      ::CompletedReviewTurnaround.create!(
        review_request_id: @review.review_request_id,
        value: caculate_completed_turnaround
      )
    end

    def caculate_completed_turnaround
      weekend_in_seconds = WeekendSecondsInterval.call(start_date: @review.opened_at, end_date: @review.pull_request.opened_at)
      (@review.opened_at.to_i - @review.pull_request.opened_at.to_i) - weekend_in_seconds
    end
  end
end
