module Builders
  module Chartkick
    class DevelopmentCycleAverageData < Builders::Chartkick::ProductData
      def build_data(metrics)
        values = metrics.inject({}) do |hash, metric|
          hash.merge!(
            metric.value_timestamp.strftime('%Y-%m-%d').to_s => metric.value[:development_cycle]
          )
        end

        metrics_length = metrics.count
        total = values.values.inject(:+)

        average = (total / metrics_length).round(1) if metrics_length.positive?

        { average: average }
      end
    end
  end
end
