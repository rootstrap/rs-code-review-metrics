module Builders
  module Chartkick
    class PlannedToDoneValueData < Builders::Chartkick::ProductData
      def build_data(metrics)
        @values = []
        metrics.map do |metric|
          sprints_points(metric.value[:planned_to_done_values])
        end

        @values
      end

      def sprints_points(sprints)
        sprints.map do |sprint|
          sprint_name = sprint[:sprint]
          @values.push(name: 'Commitment', data: { sprint_name => sprint[:committed] })
          @values.push(name: 'Completed', data: { sprint_name => sprint[:completed] })
        end
      end
    end
  end
end
