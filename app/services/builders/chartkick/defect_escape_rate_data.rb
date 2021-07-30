module Builders
  module Chartkick
    class DefectEscapeRateData < Builders::Chartkick::ProductData
      def build_data(metrics)
        metrics.inject({}) do |hash, metric|
          hash.merge!(
            metric.value_timestamp.strftime('%Y-%m-%d').to_s => metric.value[:defect_rate]
          )
        end
      end
    end
  end
end
