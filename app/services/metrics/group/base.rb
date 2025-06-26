module Metrics
  module Group
    class Base < BaseService
      def initialize(entity_name:, entity_id:, metric_name:, base_branch: nil)
        @entity_name = entity_name
        @entity_id = entity_id
        @metric_name = metric_name
        @base_branch = base_branch
      end

      def call
        Builders::Chartkick.const_get(parse_entity).call(@entity_id, query)
      end

      private

      def query
        {
          name: @metric_name,
          value_timestamp: value_timestamp,
          interval: interval,
          base_branch: @base_branch
        }
      end

      def current_time
        @current_time ||= Time.zone.now
      end

      def parse_entity
        "#{@entity_name.classify}Data"
      end
    end
  end
end
