module Metrics
  module MergeTime
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
          filtered_pull_requests.find_each(batch_size: BATCH_SIZE).lazy.each do |pull_request|
            entity = find_user_project(pull_request.owner, pull_request.project)
            entities[entity] += 1
            merge_time = calculate_merge_time(pull_request)

            create_or_update_metric(entity, merge_time)
          end
          calculate_avg(entities)
        end
      end

      def filtered_pull_requests
        Events::PullRequest.includes(:project, owner: :users_projects)
                           .where(merged_at: metric_interval)
      end

      def calculate_avg(entities)
        entities.reject { |_entity, count| count == 1 }.each do |entity, count|
          Metric.find_by!(ownable: entity, value_timestamp: metric_interval, name: :merge_time).tap do |metric|
            metric.value = metric.value / count
            metric.save!
          end
        end
      end

      def find_user_project(user, project)
        user.users_projects.detect { |user_project| user_project.project_id == project.id }
      end

      def calculate_merge_time(pull_request)
        pull_request.merged_at.to_i - pull_request.opened_at.to_i
      end

      def create_or_update_metric(entity, merge_time)
        metric = Metric.find_or_initialize_by(ownable: entity,
                                              value_timestamp: Time.zone.today.all_day,
                                              name: :merge_time)
        return metric.update!(value: (merge_time + metric.value)) if metric.persisted?

        metric.value = merge_time
        metric.save!
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
