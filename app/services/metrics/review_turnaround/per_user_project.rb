module Metrics
  module ReviewTurnaround
    class PerUserProject < Processors::Metric
      private

      def process
        today_reviews.find_each.lazy.each do |review|
          entity = find_user_project(review.owner, review.pull_request.project)
          turnaround = calculate_turnaround(review)

          find_or_create_metric(entity: entity)
            .update!(value: turnaround,
                     value_timestamp: time_interval.starting_at)
        end
      end

      def today_reviews
        Events::Review.select(:pull_request_id)
                      .joins(:review_request, owner: :users_projects, pull_request: :project)
                      .includes(:review_request)
                      .where(opened_at: Time.zone.today.all_day)
                      .order(:created_at)
                      .distinct
      end

      def find_user_project(user, project)
        user.users_projects.detect { |user_project| user_project.project_id == project.id }
      end

      def calculate_turnaround(review)
        review.review_request.created_at.to_i - review.opened_at.to_i
      end
    end
  end
end
