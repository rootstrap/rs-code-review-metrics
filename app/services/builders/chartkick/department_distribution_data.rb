module Builders
  module Chartkick
    class DepartmentDistributionData < Builders::Chartkick::Base
      def call
        [{ name: department_name,
           data: build_distribution_data(records),
           success_rate: build_success_rate(records) }]
      end

      private

      def build_success_rate(entities)
        intervals = build_distribution_data(entities)
        detail = Builders::Chartkick::Helpers::SuccessRate.call(department_name,
                                                                metric_name,
                                                                intervals)
        return unless detail

        { rate: detail.rate,
          successful: detail.successful,
          total: detail.total,
          metric_detail: detail.metric_detail }
      end

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
