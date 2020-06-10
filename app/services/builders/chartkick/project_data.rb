module Builders
  module Chartkick
    class ProjectData < Builders::Chartkick::Base
      def call
        project = Project.find(@entity_id)
        metrics = project.metrics.where(@query)
        [{ name: project.name, data: build_data(metrics) }]
      end
    end
  end
end
