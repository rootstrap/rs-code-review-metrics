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
            metric.value_timestamp.strftime('%Y-%m-%d').to_s => value_in_hours_for(metric)
          )
        end
      end

      def build_distribution_data(entities)
        entities_by_interval = entities.each_with_object(Hash.new(0)) do |entity, hash|
          interval = resolve_interval(entity)
          hash[interval] += 1
        end
        entities_by_interval.sort_by { |key, _| key }
      end

      def value_in_hours_for(entity)
        (entity.value.to_f / 1.hour.seconds).round(2)
      end

      def resolve_interval(entity)
        entity_value = value_in_hours_for(entity)
        if entity_value < 12
          '1-12'
        elsif entity_value < 24
          '12-24'
        elsif entity_value < 36
          '24-36'
        elsif entity_value < 48
          '36-48'
        elsif entity_value < 60
          '48-60'
        elsif entity_value < 72
          '60-72'
        else
          '72+'
        end
      end
    end
  end
end
