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
          entities = Hash.new(0)
          filtered_reviews_ids.lazy.each_slice(BATCH_SIZE) do |ids|
            reviews_reviews(ids) do |review|
              entity = find_user_project(review.owner, review.project)
              entities[entity] += 1
              turnaround = calculate_turnaround(review)

              create_or_update_metric(entity, turnaround)
            end
          end
          calculate_avg(entities)
        end
      end

      def reviews_reviews(ids)
        Events::Review.includes(:project, :review_request, owner: :users_projects)
                      .find(ids).each do |review|
          yield(review)
        end
      end

      def filtered_reviews_ids
        Events::Review.joins(:review_request)
                      .where(opened_at: metric_interval)
                      .order(:pull_request_id, :opened_at)
                      .pluck(Arel.sql('DISTINCT ON (reviews.pull_request_id) reviews.id'))
      end

      def calculate_avg(entities)
        entities.reject { |_entity, count| count == 1 }.each do |entity, count|
          Metric.find_by!(ownable: entity, created_at: metric_interval).tap do |metric|
            metric.value = metric.value / count
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

        metric.value = turnaround
        metric.save!
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
