module Builders
  module Chartkick
    class RepositoryDistributionData < Builders::Chartkick::Base
      def call
        [{
          name: repository_name,
          data: intervals,
          interval_metrics: build_interval_metrics
        }]
      end

      private

      def repository_name
        @repository_name ||= ::Repository.find(@entity_id).name
      end

      def retrieve_records
        @retrieve_records ||= metric.retrieve_records(
          entity_id: @entity_id,
          time_range: @query[:value_timestamp],
          base_branch: @query[:base_branch]
        )
      end

      def metric_name
        @query[:name]
      end

      def metric
        @metric ||= RepositoryDistributionDataMetrics.const_get(metric_name.to_s.camelize).new
      end

      def intervals
        @intervals ||= build_distribution_data(retrieve_records)
      end

      def resolve_interval(entity)
        metric.resolve_interval(entity)
      end

      def total_value
        @total_value ||= retrieve_records.sum { |record| metric.value_for_average(record) }
      end

      def total_records
        @total_records ||= retrieve_records.size
      end

      def success_rate
        build_success_rate(repository_name, metric_name, intervals)
      end

      def build_interval_metrics
        return if retrieve_records.empty?

        interval_data = {
          success_rate: success_rate,
          avg_number: (total_value.to_f / total_records).round(1),
          total: total_records
        }

        if metric_name == :review_coverage
          interval_data[:zero_coverage_percentage] =
            metric.zero_coverage_percentage(retrieve_records)
        end

        interval_data
      end
    end
  end
end
