module Builders
  module Chartkick
    class MetricData < BaseService
      def initialize(entity_id, entities, metric_name, period)
        @entity_id = entity_id
        @entities = entities
        @metric_name = metric_name
        @period = period
      end

      def call
        @entities.each_with_object({}) do |entity, hash|
          hash["per_#{entity}".to_sym] = Metrics::Group::Weekly.call(
            entity_name: entity,
            entity_id: @entity_id,
            metric_name: @metric_name,
            prev: @period
          )
        end
      end
    end
  end
end
