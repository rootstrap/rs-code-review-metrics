module Builders
  module Chartkick
    class RepositoryDistributionData < Builders::Chartkick::Base
      def call
        intervals = build_distribution_data(retrieve_records)

        [{
          name: repository_name,
          data: intervals,
          success_rate: build_success_rate(repository_name, metric_name, intervals)
        }]
      end

      private

      def repository_name
        @repository_name ||= ::Repository.find(@entity_id).name
      end

      def retrieve_records
        metric.retrieve_records(entity_id: @entity_id, time_range: @query[:value_timestamp])
      end

      def metric_name
        @query[:name]
      end

      def metric
        @metric ||= RepositoryDistributionDataMetrics.const_get(metric_name.to_s.camelize).new
      end

      def resolve_interval(entity)
        metric.resolve_interval(entity)
      end
    end
  end
end
