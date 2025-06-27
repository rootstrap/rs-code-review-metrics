module Builders
  module Chartkick
    class MetricData < BaseService
      def initialize(entity_id:, entities:, metric_name:, params: {})
        @entity_id = entity_id
        @entities = entities
        @metric_name = metric_name
        @from = params[:from]
        @to = params[:to]
        @base_branch = params[:base_branch]
      end

      def call
        @entities.each_with_object({}) do |entity, hash|
          hash["per_#{entity}".to_sym] = Metrics::Group::Weekly.call(
            entity_name: entity,
            entity_id: @entity_id,
            metric_name: @metric_name,
            params: {
              from: @from,
              to: @to,
              base_branch: @base_branch
            }
          )
        end
      end
    end
  end
end
