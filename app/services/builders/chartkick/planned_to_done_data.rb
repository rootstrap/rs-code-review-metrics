module Builders
  module Chartkick
    class PlannedToDoneData < Builders::Chartkick::ProductData
      def build_data(metrics)
        metrics.inject({}) do |hash, metric|
          hash.merge!(
            metric.value_timestamp.strftime('%Y-%m-%d').to_s => metric.value[:planned_to_done]
          )
        end
      end
    end
  end
end
