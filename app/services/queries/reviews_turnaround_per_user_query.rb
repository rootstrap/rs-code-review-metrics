module Queries
  class ReviewsTurnaroundPerUserQuery < BaseService
    attr_reader :time_interval

    def initialize(time_interval:)
      @time_interval = time_interval
    end

    def call
      run
    end

    private

    def query
      Events::Review.joins(:review_request, pull_request: :project).includes(:review_request)
                    .where(opened_at: @time_interval.starting_at..@time_interval.ending_at)
    end

    def run
      query.collect do |review|
        { user_id: review.owner.id,
          turnaround: [review.review_request.created_at.to_time.to_i,
                       review.opened_at.to_time.to_i].reduce(:-) }
      end
    end
  end
end
