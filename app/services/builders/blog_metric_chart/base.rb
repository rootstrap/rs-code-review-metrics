module Builders
  module BlogMetricChart
    class Base < BaseService
      def call
        Technology.all.map do |technology|
          {
            name: technology.name.titlecase,
            data: metrics_data_for(technology, metric_name)
          }
        end
      end

      private

      def metrics_data_for(technology, metric_name)
        metrics = technology.metrics
                            .where(name: metric_name)
                            .where('value_timestamp > ?', 1.year.ago)
                            .order(:value_timestamp)

        metrics.each.inject({}) do |hash, metric|
          hash.merge!(metric.value_timestamp.strftime('%B %Y') => metric.value)
        end
      end
    end
  end
end
