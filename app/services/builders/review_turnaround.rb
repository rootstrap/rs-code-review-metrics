module Builders
  class ReviewTurnaround < ::DistributionInterval
    def initialize(review_request)
      @review_request = review_request
    end

    def call
      ::ReviewTurnaround.create!(review_request: @review_request, value: calculate_turnaround)
    end

    private

    def calculate_turnaround
      seconds_interval = opened_review.to_i - @review_request.created_at.to_i
      seconds_interval - weekend_days_as_seconds(
        @review_request.created_at.to_date..review.opened_at.to_date
      )
    end

    def review
      @review ||= @review_request.reviews.first
    end

    def opened_review
      @opened_review ||= if review.opened_on_weekend?
                           review.opened_at.end_of_day
                         else
                           review.opened_at
                         end
    end
  end
end
