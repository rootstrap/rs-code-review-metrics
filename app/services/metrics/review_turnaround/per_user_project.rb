module Metrics
  module ReviewTurnaround
    class PerUserProject < BaseService
      BATCH_SIZE = 500

      def call
        process
      end

      private

      def process
        filtered_reviews_ids.each_slice(BATCH_SIZE) do |batch|
          Events::Review.eager_load(:review_request).find(batch).lazy.each do |review|
            entity = find_user_project(review.owner, review.pull_request.project)
            turnaround = calculate_turnaround(review)

            create_or_update_metric(entity, turnaround)
          end
        end
      end

      def filtered_reviews_ids
        Events::Review.joins(:review_request, owner: :users_projects, pull_request: :project)
                      .select('DISTINCT ON (reviews.pull_request_id) reviews.id')
                      .where(opened_at: Time.zone.today.all_day)
                      .order(:pull_request_id, :opened_at)
                      .map(&:id)
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
        return metric.update!(value: ((turnaround + metric.value) / 2)) if metric.persisted?

        metric.update!(value: turnaround, name: :review_turnaround)
      end
    end
  end
end
