module Builders
  module Chartkick
    class UsersProjectData < Builders::Chartkick::Base
      def initialize(project_id, query)
        @project_id = project_id
        @query = query
      end

      def call
        retrive_users_project.map do |user_project|
          metrics = user_project.metrics.where(@query)
          { name: user_project.user_name, data: build_data(metrics) }
        end
      end

      private

      def retrive_users_project
        UsersProject.where(project_id: @project_id)
      end
    end
  end
end
