module Builders
  module Chartkick
    class PlannedToDoneValueData < Builders::Chartkick::ProductData
      def build_data(metrics)
        values = metrics.inject({}) do |hash, metric|
          sprints = metric.value[:planned_to_done_values]

          hash.merge!(sprints_points(sprints))
        end
        { values: values }
      end

      def sprints_points(sprints)
        sprints.inject({}) do |hash, sprint|
          hash.merge!(sprint[:sprint] => [sprint[:committed], sprint[:completed]])
        end
      end
    end
  end
end
