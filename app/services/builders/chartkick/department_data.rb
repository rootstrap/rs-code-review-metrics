module Builders
  module Chartkick
    class DepartmentData < Builders::Chartkick::Base
      def call
        department = ::Department.find(@entity_id)

        metrics = department.metrics.where(@query)
        [{ name: department.name, data: build_data(metrics) }]
      end
    end
  end
end
