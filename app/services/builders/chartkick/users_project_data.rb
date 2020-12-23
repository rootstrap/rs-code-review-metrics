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
        metrics = Metrics
                  .const_get(@query[:name].to_s.camelize)::PerUserProject
                  .call(@query[:value_timestamp])
        metrics.select { |metric| users_projects_ids.include?(metric.ownable_id) }
      end

      def users_projects_ids
        UsersProject.where(project_id: @entity_id).pluck(:id)
      end
    end
  end
end
