module Metrics
  module Group
    class Weekly < Metrics::Group::Base
      INTERVAL = 'weekly'.freeze

      def initialize(entity_name:, entity_id:, metric_name:, number_of_previous: 3)
        @number_of_previous = number_of_previous
        super(entity_name: entity_name, entity_id: entity_id, metric_name: metric_name)
      end

      private

      def interval
        INTERVAL
      end

      def value_timestamp
        (current_time - @number_of_previous.weeks).beginning_of_week..current_time.end_of_week
      end
    end
  end
end
