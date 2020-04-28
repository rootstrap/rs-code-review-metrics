module Metrics
  module ReviewTurnaround
    class PerUserProject < BaseService
      BATCH_SIZE = 500

      def initialize(interval = nil)
        @interval = interval
      end

      def call
        process
      end

      private

      def process
        ActiveRecord::Base.transaction do
          filtered_reviews_ids.lazy.each_slice(BATCH_SIZE) do |batch|
            Events::Review.joins(:project, :review_request, :pull_request, owner: :users_projects)
                          .eager_load(:project, :review_request, owner: :users_projects)
                          .find(batch).each do |review|
              entity = find_user_project(review.owner, review.project)
              turnaround = calculate_turnaround(review)

              create_or_update_metric(entity, turnaround)
            end
          end
          calculate_avg
        end
      end

      def filtered_reviews_ids
        Events::Review.joins(:project, :review_request, :pull_request, owner: :users_projects)
                      .where(opened_at: metric_interval)
                      .order(:pull_request_id, :opened_at)
                      .pluck(Arel.sql('DISTINCT ON (reviews.pull_request_id) reviews.id'))
      end

      def pull_requests_count_per_user_project
        Events::Review.joins(:review_request, :owner, :pull_request, :project)
                      .where(opened_at: metric_interval)
                      .having(Arel.sql('COUNT(DISTINCT reviews.pull_request_id) > 1'))
                      .order(:project_id, :owner_id)
                      .group(:owner_id, :project_id)
                      .pluck(Arel.sql('COUNT(DISTINCT reviews.pull_request_id)'),
                             :owner_id, :project_id)
      end

      def calculate_avg
        pull_requests_count_per_user_project.each do |arr|
          ownable = UsersProject.find_by!(user_id: arr.second, project_id: arr.third)
          Metric.find_by!(ownable: ownable, created_at: metric_interval).tap do |metric|
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
                                              created_at: Time.zone.today.all_day,
                                              name: :review_turnaround)
        return metric.update!(value: (turnaround + metric.value)) if metric.persisted?

        metric.update!(value: turnaround)
      end

      def metric_interval
        @interval unless @interval.nil?
        @metric_interval ||= Time.zone.today.all_day
      end
    end
  end
end
