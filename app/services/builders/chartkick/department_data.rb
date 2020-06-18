module Builders
  module Chartkick
    class DepartmentData < Builders::Chartkick::Base
      def call
        department = ::Department.find_by(id: @entity_id)
        if department
          metrics = department.metrics.where(@query)
          [{ name: department.name, data: build_data(metrics) }]
        end
      end
    end
  end
end
