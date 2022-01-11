module Builders
  module Chartkick
    class MetricData < BaseService
      def initialize(entity_id, entities, metric_name, from, to)
        @entity_id = entity_id
        @entities = entities
        @metric_name = metric_name
        @from = from
        @to = to
      end

      def call
        @entities.each_with_object({}) do |entity, hash|
          hash["per_#{entity}".to_sym] = Metrics::Group::Weekly.call(
            entity_name: entity,
            entity_id: @entity_id,
            metric_name: @metric_name,
            from: @from,
            to: @to
            # prev: (@to.to_date - @from.to_date).to_i / 7
          )
        end
      end
    end
  end
end
