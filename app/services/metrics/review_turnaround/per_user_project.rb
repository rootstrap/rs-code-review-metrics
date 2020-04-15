module Metrics
  module ReviewTurnaround
    class PerUserProject < BaseService

      def call
        process
      end

      private

      def process
        retrieve_reviews.find_each.lazy.each do |review|
          
          entity = find_user_project(review.owner, review.pull_request.project)
          turnaround = calculate_turnaround(review)

          create_metric(entity, turnaround)
        end
      end

      def retrieve_reviews
        Queries::ReviewTurnaround::PerUserProject.call
      end

      def find_user_project(user, project)
        user.users_projects.detect { |user_project| user_project.project_id == project.id }
      end

      def calculate_turnaround(review)
        review.opened_at.to_i - review.review_request.created_at.to_i
      end

      def create_metric(entity, turnaround)
        Metric.create!(ownable: entity, value: turnaround)
      end
    end
  end
end
