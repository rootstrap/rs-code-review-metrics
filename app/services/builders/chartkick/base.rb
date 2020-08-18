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
            metric.value_timestamp.strftime('%Y-%m-%d').to_s => metric.value_as_hours
          )
        end
      end

      def build_distribution_data(entities)
        entities_by_interval = entities.each_with_object(Hash.new(0)) do |entity, hash|
          interval = Metrics::TimeIntervalResolver.call(entity.value_as_hours)
          hash[interval] += 1
        end
        entities_by_interval.sort_by { |key, _| key }
      end

      def value_in_hours_for(entity)
        (entity.value.to_f / 1.hour.seconds).round(2)
      end
    end
  end
end
