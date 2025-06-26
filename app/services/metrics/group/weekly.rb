module Metrics
  module Group
    class Weekly < Metrics::Group::Base
      INTERVAL = 'weekly'.freeze

      def initialize(entity_name:, entity_id:, metric_name:, params: {})
        @from = params[:from]
        @to = params[:to]
        @base_branch = params[:base_branch]
        super(
          entity_name: entity_name,
          entity_id: entity_id,
          metric_name: metric_name,
          base_branch: @base_branch
        )
      end

      private

      def interval
        INTERVAL
      end

      def value_timestamp
        from = @from || 4.weeks.ago.strftime('%Y-%m-%d')
        to = @to || Time.zone.now.strftime('%Y-%m-%d')
        from..to
      end
    end
  end
end
