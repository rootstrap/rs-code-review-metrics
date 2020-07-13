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
      @review_request.reviews.first.opened_at.to_i - @review_request.created_at.to_i
    end
  end
end
