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
      Events::Review.joins(:review_request, owner: :users_projects, pull_request: :project)
                    .includes(:review_request)
                    .where(opened_at: @time_interval.starting_at..@time_interval.ending_at)
    end

    def run
      query.lazy.collect do |review|
        { entity: find_user_project(review.owner, review.pull_request.project),
          turnaround: review.review_request.created_at.to_i - review.opened_at.to_i }
      end
    end

    def find_user_project(user, project)
      user.users_projects.detect { |user_project| user_project.project_id == project.id }
    end
  end
end
