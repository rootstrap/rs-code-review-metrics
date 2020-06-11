module Metrics
  module Group
    class Daily < Metrics::Group::Base
      FROM = 14.days
      INTERVAL = 'daily'.freeze

      private

      def interval
        INTERVAL
      end

      def value_timestamp
        FROM.ago(current_time)..current_time
      end
    end
  end
end
