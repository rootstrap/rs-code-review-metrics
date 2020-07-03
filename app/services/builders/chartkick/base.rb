module Builders
  module Chartkick
    class Base < BaseService
      def initialize(entity_id, query)
        @entity_id = entity_id
        @query = query
      end

      private

      def build_data(metrics)
        metrics.each.inject({}) do |hash, metric|
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
        case entity.value
        when 1..12
          '1-12'
        when 12..24
          '12-24'
        when 24..36
          '24-36'
        when 36..48
          '36-48'
        when 48..60
          '48-60'
        when 60..72
          '60-72'
        else
          '72+'
        end
      end
    end
  end
end
