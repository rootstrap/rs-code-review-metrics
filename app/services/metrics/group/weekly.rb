module Metrics
  module Group
    class ByWeek < Metrics::Group::Base
      INTERVAL = 'weekly'.freeze

      def initialize(project_id:, metric_name:, number_of_previous: 3)
        @project_id = project_id
        @number_of_previous = number_of_previous
        @metric_name = metric_name
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
