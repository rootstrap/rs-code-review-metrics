module Builders
  module Chartkick
    class PlannedToDoneValueData < Builders::Chartkick::ProductData
      def build_data(metrics)
        metrics.inject({}) do |hash, metric|
          hash.merge!(
            metric.value[:planned_to_done_values][:sprint] =>
            [
              metric.value[:planned_to_done_values][:completed],
              metric.value[:planned_to_done_values][:committed]
            ]
          )
        end
      end
    end
  end
end
