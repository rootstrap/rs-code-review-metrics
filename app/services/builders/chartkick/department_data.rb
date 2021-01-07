module Builders
  module Chartkick
    class DepartmentData < Builders::Chartkick::Base
      def call
        department = ::Department.find(@entity_id)

        metrics = Metrics
                  .const_get(@query[:name].to_s.camelize)::PerDepartment
                  .call(department.id, @query[:value_timestamp])
        [{ name: department.name, data: build_data(metrics) }]
      end
    end
  end
end
