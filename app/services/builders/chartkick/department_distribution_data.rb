module Builders
  module Chartkick
    class DepartmentDistributionData < Builders::Chartkick::Base
      def call
        department_name = ::Department.find(@entity_id).name

        [{ name: department_name, data: build_distribution_data(retrieve_records) }]
      end

      private

      def retrieve_records
        metric.retrieve_records(entity_id: @entity_id, time_range: @query[:value_timestamp])
      end

      def metric_name
        @query[:name]
      end

      def metric
        @metric ||= DepartmentDistributionDataMetrics.const_get(metric_name.to_s.camelize).new
      end

      def resolve_interval(entity)
        metric.resolve_interval(entity)
      end
    end
  end
end
