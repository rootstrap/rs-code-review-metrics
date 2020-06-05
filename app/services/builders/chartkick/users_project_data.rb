module Builders
  module Chartkick
    class UsersProjectData < Builders::Chartkick::Base
      def call
        retrieve_users_project.map do |user_project|
          metrics = user_project.metrics.where(@query)
          { name: user_project.user_name, data: build_data(metrics) }
        end
      end

      private

      def retrieve_users_project
        UsersProject.where(project_id: @entity_id)
      end
    end
  end
end
