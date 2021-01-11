module Builders
  module Chartkick
    class UsersProjectData < Builders::Chartkick::Base
      def call
        metrics.group_by(&:ownable_id).map do |user_project_metrics|
          user_project = UsersProject.find(user_project_metrics.first)
          { name: user_project.user_name, data: build_data(user_project_metrics.second) }
        end
      end

      private

      def metrics
        Metrics
          .const_get(@query[:name].to_s.camelize)::PerUserProject
          .call(users_ids, @query[:value_timestamp])
      end

      def users_ids
        UsersProject.where(project_id: @entity_id).pluck(:user_id)
      end
    end
  end
end
