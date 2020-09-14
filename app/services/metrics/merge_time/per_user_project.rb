module Metrics
  module MergeTime
    class PerUserProject < Metrics::BaseDevelopmentMetrics
      private

      def process
        ActiveRecord::Base.transaction do
          merge_times_in_batches do |project_id, owner_id, merge_time_value|
            entity = find_user_project(owner_id, project_id)
            create_or_update_metric(entity.id, UsersProject.name,
                                    merge_time_interval, merge_time_value, :merge_time)
          end
        end
      end

      def merge_times_in_batches
        filtered_merge_times.each do |project_id, owner_id, merge_time_value|
          yield(project_id, owner_id, merge_time_value)
        end
      end

      def filtered_merge_times
        ::MergeTime.joins(:pull_request)
                   .where(created_at: merge_time_interval)
                   .group(:project_id, :owner_id)
                   .pluck(:project_id, :owner_id, Arel.sql('AVG(merge_times.value)'))
      end

      def merge_time_interval
        @merge_time_interval ||= @interval || Time.zone.today.all_day
      end

      def find_user_project(user_id, project_id)
        user = User.find(user_id)
        user.users_projects.detect { |user_project| user_project.project_id == project_id }
      end
    end
  end
end
