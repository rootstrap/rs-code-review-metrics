module Builders
  module Chartkick
    class DepartmentDistributionData < Builders::Chartkick::Base
      def call
        intervals = build_distribution_data(records)

        [{ name: department_name,
           data: intervals,
           success_rate: build_success_rate(department_name, metric_name, intervals) }]
      end

      private

      def department_name
        @department_name ||= ::Department.find(@entity_id).name
      end

      def records
        @records ||= metric.retrieve_records(entity_id: @entity_id,
                                             time_range: @query[:value_timestamp])
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
