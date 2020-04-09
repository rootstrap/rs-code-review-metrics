module Queries
  module ReviewTurnaround
    class PerUserProject < BaseService
      attr_reader :time_interval

      def initialize(time_interval:)
        @time_interval = time_interval
      end

      def call
        execute
      end

      private

      def execute
        Events::Review.joins(:review_request, owner: :users_projects, pull_request: :project)
                      .includes(:review_request)
                      .where(opened_at: @time_interval.starting_at..@time_interval.ending_at)
      end
    end
  end
end
