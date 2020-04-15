module Queries
  module ReviewTurnaround
    class PerUserProject < BaseService
      attr_reader :time_interval

      def call
        execute
      end

      private

      def execute
        Events::Review.joins(:review_request, owner: :users_projects, pull_request: :project)
                      .includes(:review_request)
                      .where(opened_at: Date.today.all_day)
      end
    end
  end
end
