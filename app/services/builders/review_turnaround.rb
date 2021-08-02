module Builders
  class ReviewTurnaround < BaseService
    def initialize(review_request)
      @review_request = review_request
    end

    def call
      ::ReviewTurnaround.create!(review_request: @review_request, value: calculate_turnaround)
    end

    private

    def calculate_turnaround
      weekend_seconds = WeekendSecondsInterval.call(
        start_date: review_request_created_at, end_date: review_opened_at
      )
      (review_opened_at.to_i - review_request_created_at.to_i) - weekend_seconds
    end

    def review_request_created_at
      @review_request_created_at ||= @review_request.created_at
    end

    def review_opened_at
      @review_opened_at ||= first_review_or_comment
    end

    def first_review_or_comment
      (@review_request.pull_request_comments | @review_request.reviews)
        .min_by(&:opened_at).opened_at
    end
  end
end
