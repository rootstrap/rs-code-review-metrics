module Builders
  module Chartkick
    class Base < BaseService
      def initialize(entity_id, query)
        @entity_id = entity_id
        @query = query
      end

      private

      def build_data(metrics)
        metrics.inject({}) do |hash, metric|
          hash.merge!(
            metric.value_timestamp.strftime('%Y-%m-%d').to_s => value_as_hours(metric.value)
          )
        end
      end

      def value_as_hours(value)
        (value.to_f / 1.hour.seconds).round(2)
      end

      def build_distribution_data(entities)
        entities_by_interval = entities.each_with_object(Hash.new(0)) do |entity, hash|
          interval = resolve_interval(entity)
          hash[interval] += 1
        end
        entities_by_interval.sort_by { |key, _| key.slice(/[0-9]*[+-]/).to_i }
      end

      def build_success_rate(entity_name, metric_name, intervals)
        detail = Builders::Chartkick::Helpers::SuccessRate.call(entity_name,
                                                                metric_name,
                                                                intervals)
        return unless detail

        { rate: detail.rate,
          successful: detail.successful,
          total: detail.total,
          metric_detail: detail.metric_detail }
      end
    end
  end
end
