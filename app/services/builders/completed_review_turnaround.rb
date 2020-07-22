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
      @review.opened_at.to_i - @review.pull_request.opened_at.to_i
    end
  end
end
