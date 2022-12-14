module Builders
  class CompletedReviewTurnaround < BaseService
    def initialize(review)
      @review = review
    end

    def call
      ::CompletedReviewTurnaround.create!(
        review_request_id: @review.review_request_id,
        value: calculate_completed_turnaround
      )
    end

    def calculate_completed_turnaround
      review_opened_at = @review.opened_at
      pr_opened_at = @review.pull_request.opened_at
      weekend_in_seconds = WeekendSecondsInterval.call(start_date: review_opened_at,
                                                       end_date: pr_opened_at)
      (review_opened_at.to_i - pr_opened_at.to_i) - weekend_in_seconds
    end
  end
end
