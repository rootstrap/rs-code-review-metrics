module Metrics
  module Group
    class Weekly < Metrics::Group::Base
      INTERVAL = 'weekly'.freeze

      def initialize(entity_name:, entity_id:, metric_name:, prev: 3)
        @prev = prev.to_i
        super(entity_name: entity_name, entity_id: entity_id, metric_name: metric_name)
      end

      private

      def interval
        INTERVAL
      end

      def value_timestamp
        (current_time - @prev.weeks).beginning_of_week..current_time.end_of_week
      end
    end
  end
end
