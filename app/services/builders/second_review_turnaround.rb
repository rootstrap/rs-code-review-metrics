module Builders
  class SecondReviewTurnaround < BaseService
    def initialize(review)
      @review = review
    end

    def call
      ::SecondReviewTurnaround.create!(
        review_request_id: @review.review_request_id,
        value: caculate_second_turnaround
      )
    end

    def caculate_second_turnaround
      @review.opened_at.to_i - @review.pull_request.opened_at.to_i
    end
  end
end
