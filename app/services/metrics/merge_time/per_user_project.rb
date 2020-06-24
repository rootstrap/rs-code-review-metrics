module Metrics
  module MergeTime
    class PerUserProject < Metrics::BaseDevelopmentMetrics
      BATCH_SIZE = 500

      private

      def process
        ActiveRecord::Base.transaction do
          entities = Hash.new(0)
          pull_requests_in_batches do |pull_request|
            entity = find_user_project(pull_request.owner, pull_request.project)
            entities[entity] += 1
            merge_time = calculate_merge_time(pull_request)

            create_or_update_metric(entity.id, UsersProject.name,
                                    metric_interval, merge_time, :merge_time)
          end
          calculate_metrics_avg(entities, :merge_time)
        end
      end

      def pull_requests_in_batches
        filtered_pull_requests.find_each(batch_size: BATCH_SIZE).lazy.each do |pull_request|
          yield(pull_request)
        end
      end

      def filtered_pull_requests
        Events::PullRequest.includes(:project, owner: :users_projects)
                           .where(merged_at: metric_interval)
      end

      def calculate_merge_time(pull_request)
        pull_request.merged_at.to_i - pull_request.opened_at.to_i
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
