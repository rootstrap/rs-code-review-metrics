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

      def value_in_hours_for(metric)
        (metric.value.to_f / 1.hour.seconds).round(2)
      end
    end
  end
end
