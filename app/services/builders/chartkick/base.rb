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
        entities.inject({}) do |hash, entity|
          interval = resolve_interval(entity)
          hash.merge!(
            interval => value_in_hours_for(entity)
          )
        end
      end

      def value_in_hours_for(entity)
        (entity.value.to_f / 1.hour.seconds).round(2)
      end

      def resolve_interval(entity)
        if entity.value < 12
          '1-12'
        elsif entity.value < 24
          '12-24'
        elsif entity.value < 36
          '24-36'
        elsif entity.value < 48
          '36-48'
        elsif entity.value < 60
          '48-60'
        elsif entity.value < 72
          '60-72'
        else
          '72+'
        end
      end
    end
  end
end
