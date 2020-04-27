module Metrics
  module ReviewTurnaround
    class PerUserProject < BaseService
      BATCH_SIZE = 500

      def call
        process
      end

      private

      def process
        filtered_reviews_ids.lazy.each_slice(BATCH_SIZE) do |batch|
          Events::Review.eager_load(:review_request).find(batch).each do |review|
            entity = find_user_project(review.owner, review.pull_request.project)
            turnaround = calculate_turnaround(review)

            create_or_update_metric(entity, turnaround)
          end
        end
        calculate_avg
      end

      def filtered_reviews_ids
        Events::Review.joins(:review_request, owner: :users_projects, pull_request: :project)
                      .where(opened_at: Time.zone.today.all_day)
                      .order(:pull_request_id, :opened_at)
                      .pluck(Arel.sql('DISTINCT ON (reviews.pull_request_id) reviews.id'))
      end

      def pull_requests_count_per_user_project
        Events::Review.joins(:review_request, :owner, :pull_request, :project)
                      .where(opened_at: Time.zone.today.all_day)
                      .having(Arel.sql('COUNT(DISTINCT reviews.pull_request_id) > 1'))
                      .order(:project_id, :owner_id)
                      .group(:owner_id, :project_id)
                      .pluck(Arel.sql('COUNT(DISTINCT reviews.pull_request_id)'),
                             :owner_id, :project_id)
      end

      def calculate_avg
        pull_requests_count_per_user_project.each do |arr|
          ownable = UsersProject.find_by!(user_id: arr.second, project_id: arr.third)
          Metric.find_by!(ownable: ownable, created_at: Time.zone.today.all_day).tap do |metric|
            metric.value = metric.value / arr.first
            metric.save!
          end
        end
      end

      def find_user_project(user, project)
        user.users_projects.detect { |user_project| user_project.project_id == project.id }
      end

      def calculate_turnaround(review)
        review.opened_at.to_i - review.review_request.created_at.to_i
      end

      def create_or_update_metric(entity, turnaround)
        metric = Metric.find_or_initialize_by(ownable: entity,
                                              created_at: Time.zone.today.all_day)
        return metric.update!(value: (turnaround + metric.value)) if metric.persisted?

        metric.update!(value: turnaround, name: :review_turnaround)
      end
    end
  end
end
