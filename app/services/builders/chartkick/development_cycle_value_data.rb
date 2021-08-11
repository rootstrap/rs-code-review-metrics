module Builders
  module Chartkick
    class DevelopmentCycleValueData < Builders::Chartkick::ProductData
      def build_data(metrics)
        metrics.inject({}) do |hash, metric|
          hash.merge!(
            metric.value_timestamp.strftime('%Y-%m-%d').to_s => metric.value[:development_cycle]
          )
        end
      end
    end
  end
end
