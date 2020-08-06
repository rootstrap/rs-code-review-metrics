module Builders
  class ReviewTurnaround < BaseService
    SECONDS_IN_A_DAY = 86400

    def initialize(review_request)
      @review_request = review_request
    end

    def call
      ::ReviewTurnaround.create!(review_request: @review_request, value: calculate_turnaround)
    end

    private

    def calculate_turnaround
      (opened_review_request.to_i - @review_request.created_at.to_i) - weekend_days_as_seconds
    end

    def weekend_days_as_seconds
      range_days = @review_request.created_at.to_date..@review_request.reviews.first.opened_at.to_date
      weekends = range_days.select { |day| day.wday == 6 || day.wday ==0 }.count
      weekends * SECONDS_IN_A_DAY
    end

    def opened_review_request
      @review_request.reviews.first.opened_at
    end
  end
end
