module Builders
  module Chartkick
    class RepositoryDistributionData < Builders::Chartkick::Base
      REPOSITORY = 'repository'.freeze

      def call
        repository_name = ::Repository.find(@entity_id).name

        [{
          name: repository_name,
          data: build_distribution_data(retrieve_records),
          success_rate: build_success_rate(retrieve_records)
        }]
      end

      private

      def build_success_rate(entities)
        intervals = build_distribution_data(entities)

        detail = Builders::Chartkick::Helpers::SuccessRate.call(REPOSITORY,
                                                                metric_name,
                                                                intervals)

        return unless detail

        { rate: detail.rate,
          successful: detail.successful,
          total: detail.total,
          metric_detail: detail.metric_detail }
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
