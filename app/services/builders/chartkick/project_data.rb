module Builders
  module Chartkick
    class ProjectData < Builders::Chartkick::Base
      def call
        project = ::Project.find(@entity_id)

        metrics = Metrics
                  .const_get(@query[:name].to_s.camelize)::PerProject
                  .call(@query[:value_timestamp])
        [{ name: project.name, data: build_data(metrics) }]
      end
    end
  end
end
