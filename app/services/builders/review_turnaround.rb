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
      seconds_interval = opened_review.to_i - review_request_created_at.to_i
      seconds_interval - weekend_days_as_seconds(
        review_request_created_at.to_date..review_opened_at.to_date
      )
    end

    def review_request_created_at
      @review_request_created_at ||= @review_request.created_at
    end

    def review
      @review ||= @review_request.reviews.first
    end

    def opened_review
      @opened_review ||= if review.opened_on_weekend?
                           review_opened_at.end_of_day
                         else
                           review_opened_at
                         end
    end

    def review_opened_at
      @review_opened_at ||= review.opened_at
    end
  end
end
