module Builders
  class ReviewTurnaround < BaseService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      ::ReviewTurnaround.create!(pull_request: @pull_request, value: calculate_turnaround)
    end

    private

    def calculate_turnaround
      @pull_request.opened_at.to_i - @pull_request.reviews.first.created_at.to_i
    end
  end
end
