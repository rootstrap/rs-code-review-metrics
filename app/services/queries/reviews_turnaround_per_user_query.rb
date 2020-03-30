module Queries
  class ReviewsTurnaroundPerUserQuery < BaseService
    attr_reader :time_interval

    def initialize(time_interval:)
      @time_interval = time_interval
    end

    def call
      query
    end

    private

    def last_processed_review
      Events::Review
        .where(created_at: @time_interval.starting_at..@time_interval.ending_at)
        .order(created_at: :desc)
        .first
    end

    def query
      Events::Review.joins(:review_request, pull_request: :project).includes(:review_request)
                    .where(created_at: @time_interval.starting_at..@time_interval.ending_at)
                    .collect do |review|
                      { user_id: review.owner.id,
                        turnaround: (review.opened_at.to_i - review.review_request.created_at.to_i) }
                    end
    end
  end
end
