module Queries
  class ReviewsTurnaroundPerUserProjectQuery < BaseService
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
        { entity: find_user_project(review.owner, review.pull_request.project),
          turnaround: [review.review_request.created_at.to_i,
                       review.opened_at.to_i].reduce(:-) }
      end
    end

    def find_user_project(user, project)
      UsersProject.find_by!(user: user, project: project)
    end
  end
end
