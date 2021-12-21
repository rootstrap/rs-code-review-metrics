module Metrics
  module Group
    class Weekly < Metrics::Group::Base
      INTERVAL = 'weekly'.freeze

      def initialize(entity_name:, entity_id:, metric_name:, from:, to:)
        @from = from
        @to= to
        super(entity_name: entity_name, entity_id: entity_id, metric_name: metric_name)
      end

      private

      def interval
        INTERVAL
      end

      def value_timestamp
        from= @from || (Time.now - 28.day).strftime("%Y-%m-%d")
        to= @to || Time.now.strftime("%Y-%m-%d")
        from.to_date..to.to_date
      end
    end
  end
end
