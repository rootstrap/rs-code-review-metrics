module Builders
  module Chartkick
    class ProjectData < Builders::Chartkick::Base
      def initialize(project_id, query)
        @project_id = project_id
        @query = query
      end

      def call
        project = Project.find(@project_id)
        metrics = project.metrics.where(@query)
        [{ name: project.name, data: build_data(metrics) }]
      end
    end
  end
end
